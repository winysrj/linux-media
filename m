Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m5QG99iY011057
	for <video4linux-list@redhat.com>; Thu, 26 Jun 2008 12:09:09 -0400
Received: from fg-out-1718.google.com (fg-out-1718.google.com [72.14.220.159])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m5QG8wrH024787
	for <video4linux-list@redhat.com>; Thu, 26 Jun 2008 12:08:58 -0400
Received: by fg-out-1718.google.com with SMTP id e21so53129fga.7
	for <video4linux-list@redhat.com>; Thu, 26 Jun 2008 09:08:58 -0700 (PDT)
Message-ID: <30353c3d0806260908u68a3d658u76c15e6649f8b82a@mail.gmail.com>
Date: Thu, 26 Jun 2008 12:08:58 -0400
From: "David Ellingsworth" <david@identd.dyndns.org>
To: video4linux-list@redhat.com
In-Reply-To: <20080626101331.GC6707@devserv.devel.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <30353c3d0806251251v6f91a7efy7ceedab39a42f0a6@mail.gmail.com>
	<20080626101331.GC6707@devserv.devel.redhat.com>
Subject: Re: Bug in stv680
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>

On Thu, Jun 26, 2008 at 6:13 AM, Alan Cox <alan@redhat.com> wrote:
> On Wed, Jun 25, 2008 at 03:51:33PM -0400, David Ellingsworth wrote:
>>      1. Application 1 opens the device. stv680->user transitions from 0->1
>>      2. Application 2 opens the device. stv680->user transitions from 1->1
>>      3. Application 2 closes the device. stv680->user transitions from 1->0
>>      4. Device is physically disconnected. stv680 is freed.
>>      5. Application 1 closes the device.
>>
>> The crash could happen at step 4 in stv680_read, stv680_mmap, or
>> stv680_do_ioctl, or at step 5 in stv_close depending on how
>> Application 1 is using the device.
>
> Yes I think you are right
>
>> The apparent fix for this, is that stv680->user should be incremented
>> whenever the device is opened, and decremented when it is closed.
>> Likewise, a lock should be used to guarantee exclusive access to
>> stv680->user to avoid a race condition between stv_open and stv_close.
>> This should correct the case where the structure is freed by
>> stv_disconnect while it is still open and in use.
>
> Currently open/close use the big kernel lock so the locking part is ok. The
> 'proper' kernel way to do this is to use krefs which basically implement
> the locking you describe but using atomic_inc/dec and atomic decrement and
> compare with zero operations from the various architecture layers.
>
>
> Something like
>
> struct stv680 *stv_get(struct stv680 *v)
> {
>        kref_get(&v->kref);
> }
>
> void stv_put(struct stv680 *)
> {
>        kref_put(&v->kref, stv_free_thingies);
> }
>
>
> One camera driver that does use krefs properly (they are fairly new so
> a lot of drivers don't yet adopt them) is the stk-webcam driver which uses
> them for open/close as you describe.
>
>
>
Thanks for clarifying the locking structure. Somehow I missed the
comment about the BKL being held. None the less, the scenario I
provided should result in a crash due an invalid internal reference
count.

Regards,

David Ellingsworth

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list

Return-path: <video4linux-list-bounces@redhat.com>
Date: Thu, 26 Jun 2008 06:13:31 -0400
From: Alan Cox <alan@redhat.com>
To: David Ellingsworth <david@identd.dyndns.org>
Message-ID: <20080626101331.GC6707@devserv.devel.redhat.com>
References: <30353c3d0806251251v6f91a7efy7ceedab39a42f0a6@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <30353c3d0806251251v6f91a7efy7ceedab39a42f0a6@mail.gmail.com>
Cc: video4linux-list@redhat.com
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

On Wed, Jun 25, 2008 at 03:51:33PM -0400, David Ellingsworth wrote:
>      1. Application 1 opens the device. stv680->user transitions from 0->1
>      2. Application 2 opens the device. stv680->user transitions from 1->1
>      3. Application 2 closes the device. stv680->user transitions from 1->0
>      4. Device is physically disconnected. stv680 is freed.
>      5. Application 1 closes the device.
> 
> The crash could happen at step 4 in stv680_read, stv680_mmap, or
> stv680_do_ioctl, or at step 5 in stv_close depending on how
> Application 1 is using the device.

Yes I think you are right

> The apparent fix for this, is that stv680->user should be incremented
> whenever the device is opened, and decremented when it is closed.
> Likewise, a lock should be used to guarantee exclusive access to
> stv680->user to avoid a race condition between stv_open and stv_close.
> This should correct the case where the structure is freed by
> stv_disconnect while it is still open and in use.

Currently open/close use the big kernel lock so the locking part is ok. The
'proper' kernel way to do this is to use krefs which basically implement
the locking you describe but using atomic_inc/dec and atomic decrement and
compare with zero operations from the various architecture layers.


Something like

struct stv680 *stv_get(struct stv680 *v)
{
	kref_get(&v->kref);
}

void stv_put(struct stv680 *)
{
	kref_put(&v->kref, stv_free_thingies);
}


One camera driver that does use krefs properly (they are fairly new so
a lot of drivers don't yet adopt them) is the stk-webcam driver which uses
them for open/close as you describe.


--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list

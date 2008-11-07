Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx1.redhat.com (mx1.redhat.com [172.16.48.31])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mA776j9q022648
	for <video4linux-list@redhat.com>; Fri, 7 Nov 2008 02:06:46 -0500
Received: from smtp6.versatel.nl (smtp6.versatel.nl [62.58.50.97])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id mA776ZdD011526
	for <video4linux-list@redhat.com>; Fri, 7 Nov 2008 02:06:36 -0500
Message-ID: <4913E9DB.8040801@hhs.nl>
Date: Fri, 07 Nov 2008 08:10:19 +0100
From: Hans de Goede <j.w.r.degoede@hhs.nl>
MIME-Version: 1.0
To: David Ellingsworth <david@identd.dyndns.org>
References: <491339D9.2010504@personnelware.com>
	<30353c3d0811061553h4c1a77e0t597bd394fa0ebdf1@mail.gmail.com>
In-Reply-To: <30353c3d0811061553h4c1a77e0t597bd394fa0ebdf1@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: video4linux-list@redhat.com
Subject: Re: weeding out v4l ver 1 stuff
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

David Ellingsworth wrote:
> On Thu, Nov 6, 2008 at 1:39 PM, Carl Karsten <carl@personnelware.com> wrote:
>> Given v4l version 1 is being dropped in December 08, we should remove stuff that
>> targets that api, right?
>>
>> For instance:
>>
>> http://linuxtv.org/hg/v4l-dvb/file/b45ffc93fb82/v4l2-apps/test/v4lgrab.c
>>
>>      94 #ifdef CONFIG_VIDEO_V4L1_COMPAT
>>      194 #else
>>
>>      195       fprintf(stderr, "V4L1 API is not configured!\n");
>>
>> I'll let someone else figure out if the whole file should be removed, or if it
>> has some value to v2.
>>
>> And assuming someone agrees we should week out v1 stuff, where is the right
>> place to log this too?  http://bugzilla.kernel.org does not seem right.
>>
>> Carl K
>>
> 
> With v4l1 going away, it would be nice to convert any drivers still
> using the v4l1 interface to v4l2. Drivers using usbvideo spring to
> mind. I've mentioned in the past, I've started a rewrite of ibmcam
> over to the v4l2 interface but I currently don't have much time to
> work on it and could use some assistance from the community. While
> Mauro suggested it be written against the gspca framework, I hesitate
> to do so since gspca does it's own memory management and will probably
> become somewhat obsolete once the new media framework is put together.

? What new media framework ? You mean the planned changes to the v4l2 API for 
multifunction devices? Anyways this won't make gspca obsolete, gspca is a 
framework for writing usb webcam drivers, as such it tries to do things common 
to all usb webcam drivers inside the gspca-core. If the v4l2 core changes the 
gspca-core will adapt and in most cases of v4l2-core changes, the gspca 
subdrivers will not need to change at all. So if anything using gspca makes 
your driver more future proof against v4l2-core changes as in most cases the 
necessary changes for all gspca drivers only need to be made once in gspca-core

Regards,

Hans

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list

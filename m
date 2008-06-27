Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m5REns4G001276
	for <video4linux-list@redhat.com>; Fri, 27 Jun 2008 10:49:54 -0400
Received: from fg-out-1718.google.com (fg-out-1718.google.com [72.14.220.155])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m5REnhRe032650
	for <video4linux-list@redhat.com>; Fri, 27 Jun 2008 10:49:43 -0400
Received: by fg-out-1718.google.com with SMTP id e21so299982fga.7
	for <video4linux-list@redhat.com>; Fri, 27 Jun 2008 07:49:43 -0700 (PDT)
Message-ID: <30353c3d0806270749t557e8fa8h3f96b86eab310669@mail.gmail.com>
Date: Fri, 27 Jun 2008 10:49:43 -0400
From: "David Ellingsworth" <david@identd.dyndns.org>
To: video4linux-list@redhat.com
In-Reply-To: <30353c3d0806261413q480fd024y27a1bb2ee6bb4e85@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <30353c3d0806261413q480fd024y27a1bb2ee6bb4e85@mail.gmail.com>
Subject: Re: Expected video_unregister_device behavior.
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

On Thu, Jun 26, 2008 at 5:13 PM, David Ellingsworth
<david@identd.dyndns.org> wrote:
> It is my understanding that video_unregister_device is responsible for
> removing the /dev/video* device from the system. To this regard, I
> have seen a lot of usb camera drivers calling video_unregister_device
> in the usb disconnect callback to ensure that no one subsequently
> tries to open the device again. Mimicking the existing drivers, I did
> the same. What I found was that calling video_unregister_device
> resulted in calling the release function of the video_device structure
> despite the fact the device was still open. The log from my tests
> showed the following:
>
> usb_probe_callback
>     - video_register_device called
> video_open_callback - This seem to happen automatically upon
> video_register_device
> video_close_callback - same as above
> video_open_callback - caused by application open
> usb_disconnect_callback
>     - device physically disconnected
>     - calls video_unregister_device to prevent future opens
> video_release_callback
>     - called as a result of video_unregister_device but the device is
> still open!
> video_close_callback
>     - application noticed read error and closed device
>
> I have not yet looked to see why the video_release_callback is being
> called after video_unregister_device is called, but I would have
> expected it not to have been called until after the final
> video_close_callback has been issued. My question, is therefore, is
> this the desired behavior? Should a call to video_unregister_device
> immediately cause the video_release_callback to be called?
>

I just wanted to follow up on this as I've found a work-around for the
issue I was experiencing.

I had been using video_devdata(file) inside of close to retrieve the
video device data from the file as I thought this was the preferred
method. In the case above the return value of video_devdata in the
final close is NULL. To overcome this limitation I set
file->private_data in the open callback to my internal struct so I
could retrieve it during the final close. Thus, giving the opportunity
to properly free the struct. I suspect other drivers may have the same
issue, but I have not investigated them as of yet.

Regards,

David Ellingsworth

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list

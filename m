Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m6VLnsYw029977
	for <video4linux-list@redhat.com>; Thu, 31 Jul 2008 17:49:54 -0400
Received: from mail.gmx.net (mail.gmx.net [213.165.64.20])
	by mx3.redhat.com (8.13.8/8.13.8) with SMTP id m6VLngrZ032436
	for <video4linux-list@redhat.com>; Thu, 31 Jul 2008 17:49:42 -0400
Date: Thu, 31 Jul 2008 23:49:37 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Robert Jarzmik <robert.jarzmik@free.fr>
In-Reply-To: <87tze53jz8.fsf@free.fr>
Message-ID: <Pine.LNX.4.64.0807312328100.4832@axis700.grange>
References: <1217113647-20638-1-git-send-email-robert.jarzmik@free.fr>
	<Pine.LNX.4.64.0807270155020.29126@axis700.grange>
	<878wvnkd8n.fsf@free.fr>
	<Pine.LNX.4.64.0807271337270.1604@axis700.grange>
	<87tze997uu.fsf@free.fr>
	<Pine.LNX.4.64.0807291902200.17188@axis700.grange>
	<87iqun2ge3.fsf@free.fr>
	<Pine.LNX.4.64.0807310008190.26534@axis700.grange>
	<87tze53jz8.fsf@free.fr>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: video4linux-list@redhat.com
Subject: Re: [PATCH] Fix suspend/resume of pxa_camera driver
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

On Thu, 31 Jul 2008, Robert Jarzmik wrote:

> Guennadi Liakhovetski <g.liakhovetski@gmx.de> writes:
> 
> > Ok, you're suggesting to add suspend() and resume() to 
> > soc_camera_bus_type, right? But are we sure that its resume will be called 
> > after both camera (so far i2c) and host (so far platform, can also be PCI 
> > or USB...) busses are resumed? If not, we might have to do something 
> > similar to scan_add_host() / scan_add_device() - accept signals from the 
> > host and the camera and when both are ready actually resume them...
> 
> As far as my comprehension goes for resume order :
>  - mt9m111 is an i2c client, and so it will always be resumed after i2c bus
>  driver
>  - mt9m111 registers itself to the soc_camera bus, so soc_camera_bus will be
>  resumed after mt9m111
>  - pxa27-camera registers to soc_camera_host, so soc_camera_host will be resumed
>  after pxa27-camera
>  - I didn't check the link between soc_camera_host and soc_camera_bus, but if
>  there is one, soc_camera bus is resumed last.

I thought devices get woken up after busses they are on and after their 
parents, am I wrong? If I am right, the last one to be woken up were the 
camera device.

> So, if I have it sorted out correctly, soc_camera_bus should hold the suspend()
> and resume() functions, which will call icd->ops->suspend() and
> icd->ops->resume().
> 
> I'm still investigating these points (under test ATM). It does work, but I still
> haven't got the formal proof of the ordering ...
> 
> Would you by any chance have a little ascii art of all
> camera/camera_host/camera_bus ... device graph ? A thing that could easily be
> pushed into Documentation/video4linux/... ?

I started documenting the API, honestly:-) But ATM I have no time for that 
again... As for the device hierarchy, the device embedded into the camera 
device object (struct soc_camera_device) is registered on the soc-camera 
bus (soc_camera_bus_type), and has the device from the camera host object 
as parent. In case of the pxa-camera driver that device object in turn has 
the platform device as a parent. From my system:

# This is the camera device
~ ls -l /sys/bus/soc-camera/devices/
lrwxrwxrwx    1 root     root            0 Jan  1 00:01 0-0 -> ../../../devices/platform/pxa27x-camera.0/camera_host0/0-0

# It is linked with the "control" link with the respective i2c device and 
# provides the video0 device
~ ls -l /sys/bus/soc-camera/devices/0-0/
lrwxrwxrwx    1 root     root            0 Jan  1 00:01 bus -> ../../../../../bus/soc-camera
lrwxrwxrwx    1 root     root            0 Jan  1 00:01 control -> ../../../../../class/i2c-adapter/i2c-0/0-0048
lrwxrwxrwx    1 root     root            0 Jan  1 00:01 driver -> ../../../../../bus/soc-camera/drivers/camera
lrwxrwxrwx    1 root     root            0 Jan  1 00:01 subsystem -> ../../../../../bus/soc-camera
-rw-r--r--    1 root     root         4096 Jan  1 00:01 uevent
lrwxrwxrwx    1 root     root            0 Jan  1 00:01 video4linux:video0 -> ../../../../../class/video4linux/video0

# As a parent it has the camera host device
~ ls -l /sys/bus/platform/devices/pxa27x-camera.0/
lrwxrwxrwx    1 root     root            0 Jan  1 00:01 bus -> ../../../bus/platform
drwxr-xr-x    3 root     root            0 Jan  1 00:01 camera_host0
lrwxrwxrwx    1 root     root            0 Jan  1 00:01 driver -> ../../../bus/platform/drivers/pxa27x-camera
-r--r--r--    1 root     root         4096 Jan  1 00:01 modalias
lrwxrwxrwx    1 root     root            0 Jan  1 00:01 subsystem -> ../../../bus/platform
-rw-r--r--    1 root     root         4096 Jan  1 00:00 uevent

# And here's again the child of the camera host device
~ ls -l /sys/bus/platform/devices/pxa27x-camera.0/camera_host0/
drwxr-xr-x    2 root     root            0 Jan  1 00:01 0-0
-rw-r--r--    1 root     root         4096 Jan  1 00:01 uevent

HTH
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list

Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m1C3KE6b023563
	for <video4linux-list@redhat.com>; Mon, 11 Feb 2008 22:20:14 -0500
Received: from wx-out-0506.google.com (wx-out-0506.google.com [66.249.82.228])
	by mx3.redhat.com (8.13.1/8.13.1) with ESMTP id m1C3Jg62005157
	for <video4linux-list@redhat.com>; Mon, 11 Feb 2008 22:19:42 -0500
Received: by wx-out-0506.google.com with SMTP id t16so4315977wxc.6
	for <video4linux-list@redhat.com>; Mon, 11 Feb 2008 19:19:42 -0800 (PST)
Date: Mon, 11 Feb 2008 19:18:33 -0800
From: Brandon Philips <brandon@ifup.org>
To: Nathanael Galpin <NathanaelGalpin@smarttech.com>
Message-ID: <20080212031833.GA12602@plankton.ifup.org>
References: <8FF3AEDFC5ABAE42A50A92DBBFD702EF02C1E59E@calmail1.smarttech.inc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8FF3AEDFC5ABAE42A50A92DBBFD702EF02C1E59E@calmail1.smarttech.inc>
Cc: video4linux-list@redhat.com
Subject: Re: Device Identification
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

On 10:37 Mon 11 Feb 2008, Nathanael Galpin wrote:
> Is there any way through the V4L2 API to get a device's product and
> vendor ID?

No, but you can get it by recursing the sysfs tree.

e.x.

/sys/devices/pci0000:00/0000:00:1e.0/0000:01:00.0/video4linux/video0
/sys/devices/pci0000:00/0000:00:1e.0/0000:01:00.0/video4linux/video0/uevent
/sys/devices/pci0000:00/0000:00:1e.0/0000:01:00.0/video4linux/video0/dev
/sys/devices/pci0000:00/0000:00:1e.0/0000:01:00.0/video4linux/video0/subsystem
/sys/devices/pci0000:00/0000:00:1e.0/0000:01:00.0/video4linux/video0/device
/sys/devices/pci0000:00/0000:00:1e.0/0000:01:00.0/video4linux/video0/name
/sys/devices/pci0000:00/0000:00:1e.0/0000:01:00.0/video4linux/video0/power
/sys/devices/pci0000:00/0000:00:1e.0/0000:01:00.0/video4linux/video0/power/wakeup

Hope that helps.

	Brandon

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list

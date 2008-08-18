Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m7I8rfxu020414
	for <video4linux-list@redhat.com>; Mon, 18 Aug 2008 04:53:41 -0400
Received: from fg-out-1718.google.com (fg-out-1718.google.com [72.14.220.159])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m7I8rSNC027868
	for <video4linux-list@redhat.com>; Mon, 18 Aug 2008 04:53:29 -0400
Received: by fg-out-1718.google.com with SMTP id e21so1553462fga.7
	for <video4linux-list@redhat.com>; Mon, 18 Aug 2008 01:53:28 -0700 (PDT)
Message-ID: <6f18c5ee0808180153h7d25999bh6c5dba01127aace7@mail.gmail.com>
Date: Mon, 18 Aug 2008 11:53:28 +0300
From: "Henri Tuomola" <htuomola@gmail.com>
To: video4linux-list@redhat.com
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Subject: Terratec Cinergy DT XS Diversity new version
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

Hi,

I just got the Terratec Cinergy DT XS Diversity stick, the newer one that is
mentioned in here:
http://linuxtv.org/wiki/index.php/TerraTec_Cinergy_DT_USB_XS_Diversity#Identification,
with usb id 0ccd:0081. As suggested, I tried to patch the current hg-version
with this patch:
http://www.linuxtv.org/pipermail/linux-dvb/2008-June/026911.html. However,
the patch fails, apparently because contents of the dib0700_devices.c have
changed since the diff was created. I think I figured out the syntax in
there and made some modifications so that it should be fine. After this I
ran "make" and then "modprobe dvb_usb_dib0700".

In dmesg I only get this:
dib0700: loaded with support for 7 different device-types
usbcore: registered new interface driver dvb_usb_dib0700

Seems that the card isn't detected? Any tips?

I'm running gentoo-sources-2.6.24-r8 with the v4l hg sources.

best regards,
Henri
--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list

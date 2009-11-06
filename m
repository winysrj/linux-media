Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qy0-f174.google.com ([209.85.221.174]:55027 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753474AbZKFXTL (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 6 Nov 2009 18:19:11 -0500
Received: by qyk4 with SMTP id 4so658880qyk.33
        for <linux-media@vger.kernel.org>; Fri, 06 Nov 2009 15:19:16 -0800 (PST)
MIME-Version: 1.0
Date: Sat, 7 Nov 2009 00:19:16 +0100
Message-ID: <156a113e0911061519w7da4e29ag9a8d85a76df679a9@mail.gmail.com>
Subject: "Winfast tv USB II" and "Winfast tv USB II Deluxe" share same ID
	(0413:6023), I maybe found a way to tell them apart.
From: Magnus Alm <magnus.alm@gmail.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi!

Since "Winfast tv USB II2 is a EM2800 board and "Winfast tv USB II
Deluxe" is a EM2820, I made this little hack in em28xx-cards.c
(the lines I added in "em28xx_usb_probe" is marked with "*")

snprintf(dev->name, 29, "em28xx #%d", nr);
	dev->devno = nr;
	dev->model = id->driver_info;
*      if (dev->model == EM2800_BOARD_LEADTEK_WINFAST_USBII)
*		/* Leadtek didn't make a new product id for Winfast tv usbii deluxe. */
*		retval = check_leadtek_winfast_usbii_model(&dev, udev, interface,
nr);
	dev->alt   = -1;


And the function:


/* Check if EM2800_BOARD_LEADTEK_WINFAST_USBII really is what it is or
is his/her younger sister/brother,
with the same ID. */
static int check_leadtek_winfast_usbii_model(struct em28xx
**devhandle, struct usb_device *udev,
			   struct usb_interface *interface,
			   int minor)
{
	struct em28xx *dev = *devhandle;
	int retval;
	
	dev->udev = udev;
	mutex_init(&dev->ctrl_urb_lock);
	spin_lock_init(&dev->slock);
	init_waitqueue_head(&dev->open);
	init_waitqueue_head(&dev->wait_frame);
	init_waitqueue_head(&dev->wait_stream);

	dev->em28xx_read_reg = em28xx_read_reg;
		
	retval = em28xx_read_reg(dev, EM28XX_R0A_CHIPID);
	if (retval == 18)
		dev->model = EM2820_BOARD_LEADTEK_WINFAST_USBII_DELUXE;
		em28xx_set_model(dev);
		return 0;
}

I don't think it should interfere with any other boards, but I might be wrong.
It seems to work here atleast.

/Magnus Alm

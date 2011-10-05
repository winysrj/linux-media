Return-path: <linux-media-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:55114 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757988Ab1JEIPx (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 5 Oct 2011 04:15:53 -0400
From: Oliver Neukum <oneukum@suse.de>
To: Antti Palosaari <crope@iki.fi>
Subject: Re: serial device name for smart card reader that is integrated to Anysee DVB USB device
Date: Wed, 5 Oct 2011 10:16:06 +0200
Cc: Greg KH <greg@kroah.com>, linux-serial@vger.kernel.org,
	linux-media@vger.kernel.org, linux-usb@vger.kernel.org,
	=?iso-8859-1?q?Bj=F8rn_Mork?= <bjorn@mork.no>,
	"James Courtier-Dutton" <james.dutton@gmail.com>,
	HoP <jpetrous@gmail.com>,
	=?iso-8859-1?q?Istv=E1n_V=E1radi?= <ivaradi@gmail.com>
References: <4E8B7901.2050700@iki.fi> <201110050815.17949.oneukum@suse.de> <4E8BF6DE.1010105@iki.fi>
In-Reply-To: <4E8BF6DE.1010105@iki.fi>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201110051016.06291.oneukum@suse.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Am Mittwoch, 5. Oktober 2011, 08:19:10 schrieb Antti Palosaari:
> On 10/05/2011 09:15 AM, Oliver Neukum wrote:

> > But, Greg, Antti makes a very valid point here. The generic code assumes that
> > it owns intfdata, that is you cannot use it as is for access to anything that lacks
> > its own interface. But this is not a fatal flaw. We can alter the generic code to use
> > an accessor function the driver can provide and make it default to get/set_intfdata
> >
> > What do you think?
> 
> Oliver, I looked your old thread reply but I didn't catch how you meant 
> it to happen. Could you give some small example?

Look at this structure:

struct dvb_usb_device {
        struct dvb_usb_device_properties props;
        struct dvb_usb_device_description *desc;

        struct usb_device *udev;

#define DVB_USB_STATE_INIT        0x000
#define DVB_USB_STATE_I2C         0x001
#define DVB_USB_STATE_DVB         0x002
#define DVB_USB_STATE_REMOTE      0x004
        int state;

        int powered;

        /* locking */
        struct mutex usb_mutex;

        /* i2c */
        struct mutex i2c_mutex;
        struct i2c_adapter i2c_adap;

        int                    num_adapters_initialized;
        struct dvb_usb_adapter adapter[MAX_NO_OF_ADAPTER_PER_DEVICE];

        /* remote control */
        struct rc_dev *rc_dev;
        struct input_dev *input_dev;
        char rc_phys[64];
        struct delayed_work rc_query_work;
        u32 last_event;
        int last_state;

        struct module *owner;

        void *priv;
};

It contains a pointer to an input device. You could add a pointer to a usb
serial device here. This leaves you with two problems.

1. The USB serial layer will try to set intfdata

We will need to change it to use a function the driver provides to store
a pointer to its private data.

2. The usb serial layer will not learn about events it needs to learn about.

We need to extended the usb dvb code to call into a sufficiently abstracted
method in the usb serial code.


Conceptually the usb serial code is ready to share an interface among
multiple serial ports, but not to share an interface with something else.
I described the steps necesary to allow that. This is new, so there are
no examples.

	Regards
		Oliver

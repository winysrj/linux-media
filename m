Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m7GBaV4k018941
	for <video4linux-list@redhat.com>; Sat, 16 Aug 2008 07:36:31 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m7GBaKjK027890
	for <video4linux-list@redhat.com>; Sat, 16 Aug 2008 07:36:21 -0400
Date: Sat, 16 Aug 2008 08:36:13 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: majortrips@gmail.com
Message-ID: <20080816083613.51071257@mchehab.chehab.org>
In-Reply-To: <20080816050023.GB30725@thumper>
References: <20080816050023.GB30725@thumper>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: video4linux-list@redhat.com
Subject: Re: [PATCH] Add support for OmniVision OV534 based USB cameras.
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

Hi Mark,

First of all, please review your patch with checkpatch.pl. I've seen a few
non-compliances. 

If you're using -hg tree, this is as simple as doing: make
checkpatch. Otherwise, you can use v4l/scripts/checkpatch.pl <my patch>

I have also a few other comments:

> +		switch (data & 0xFF) {

The better is that all hexadecimal values to be on lowercase.
> +static void ov534_setup(struct usb_device *udev)
> +{
> +	ov534_reg_verify_write(udev, 0xe7, 0x3a);
> +
> +	ov534_reg_write(udev, OV534_REG_ADDRESS, 0x60);
> +	ov534_reg_write(udev, OV534_REG_ADDRESS, 0x60);
> +	ov534_reg_write(udev, OV534_REG_ADDRESS, 0x60);

	Hmm... three times the same write?

> +	ov534_reg_write(udev, OV534_REG_ADDRESS, 0x42);
> +
> +	ov534_reg_verify_write(udev, 0xc2,0x0c);
	...
> +	ov534_reg_verify_write(udev, 0xe7,0x3e);

It is generally better and smaller to have a table instead of those long init sequences.


> +static void ov534_fillbuff(struct ov534_dev *dev, struct ov534_buffer *buf)
> +{

> +	tmpbuf = kmalloc(size + 4, GFP_ATOMIC);
> +	if (!tmpbuf)
> +		return;

It would be better if you allocate the buffer at videobuf prep routines, instead of doing this for every buffer fill. Is there any reason why you just don't use vbuf instead of doing double buffering?

> +	/* Updates stream time */
> +
> +	dev->ms += jiffies_to_msecs(jiffies-dev->jiffies);
> +	dev->jiffies = jiffies;
> +	if (dev->ms >= 1000) {
> +		dev->ms -= 1000;
> +		dev->s++;
> +		if (dev->s >= 60) {
> +			dev->s -= 60;
> +			dev->m++;
> +			if (dev->m > 60) {
> +				dev->m -= 60;
> +				dev->h++;
> +				if (dev->h > 24)
> +					dev->h -= 24;
> +			}
> +		}
> +	}
> +	sprintf(dev->timestr, "%02d:%02d:%02d:%03d",
> +			dev->h, dev->m, dev->s, dev->ms);

You don't need the above. This is at vivi just because we want to print a
timestamp at the video. Just remove it and timestr from dev.

I also didn't see any code to provide S1/S3 hibernation. This is probably not
needed at vivi (since there's no hardware registers to be saved/restored - yet
- I never tried to do suspend/resume with vivi working), but for sure this is
needed for real devices ;) I suggest you to take a look, for example, at
cafe_ccic, for its implementation (it is inside #ifdef CONFIG_PM).

Cheers,
Mauro

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list

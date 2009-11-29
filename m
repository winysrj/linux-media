Return-path: <linux-media-owner@vger.kernel.org>
Received: from kroah.org ([198.145.64.141]:56931 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752925AbZK2TLo (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 29 Nov 2009 14:11:44 -0500
Date: Sun, 29 Nov 2009 11:09:57 -0800
From: Greg KH <greg@kroah.com>
To: Jon Smirl <jonsmirl@gmail.com>
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-input@vger.kernel.org
Subject: Re: [IR-RFC PATCH v4 2/6] Core IR module
Message-ID: <20091129190957.GB6171@kroah.com>
References: <20091127013217.7671.32355.stgit@terra> <20091127013423.7671.36546.stgit@terra> <20091129171726.GB4993@kroah.com> <9e4733910911290941o761a4dfhf4168e573c6b6e89@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9e4733910911290941o761a4dfhf4168e573c6b6e89@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, Nov 29, 2009 at 12:41:22PM -0500, Jon Smirl wrote:
> On Sun, Nov 29, 2009 at 12:17 PM, Greg KH <greg@kroah.com> wrote:
> >> +static ssize_t ir_raw_show(struct device *dev,
> >> + ? ? ? ? ? ? ? ? ? ? ? ? ? ? ?struct device_attribute *attr, char *buf)
> >> +{
> >> + ? ? struct input_dev *input_dev = to_input_dev(dev);
> >> + ? ? unsigned int i, count = 0;
> >> +
> >> + ? ? for (i = input_dev->ir->raw.tail; i != input_dev->ir->raw.head; ) {
> >> +
> >> + ? ? ? ? ? ? count += snprintf(&buf[count], PAGE_SIZE - 1, "%i\n", input_dev->ir->raw.buffer[i++]);
> >> + ? ? ? ? ? ? if (i > ARRAY_SIZE(input_dev->ir->raw.buffer))
> >> + ? ? ? ? ? ? ? ? ? ? i = 0;
> >> + ? ? ? ? ? ? if (count >= PAGE_SIZE - 1) {
> >> + ? ? ? ? ? ? ? ? ? ? input_dev->ir->raw.tail = i;
> >> + ? ? ? ? ? ? ? ? ? ? return PAGE_SIZE - 1;
> >> + ? ? ? ? ? ? }
> >> + ? ? }
> >> + ? ? input_dev->ir->raw.tail = i;
> >> + ? ? return count;
> >> +}
> >
> > This looks like it violates the "one value per sysfs file" rule that we
> > have. ?What exactly are you outputting here? ?It does not look like this
> > belongs in sysfs at all.
> 
> It should be on a debug switch or maybe a debug device. If the rest of
> the system is working right you shouldn't need this data.

Then why export it at all?

If it's debug stuff, please use debugfs, that is what it is there for.

thanks,

greg k-h

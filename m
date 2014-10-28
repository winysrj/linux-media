Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp206.alice.it ([82.57.200.102]:49756 "EHLO smtp206.alice.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751254AbaJ1OkI (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 28 Oct 2014 10:40:08 -0400
Date: Tue, 28 Oct 2014 15:39:41 +0100
From: Antonio Ospite <ao2@ao2.it>
To: Hans de Goede <hdegoede@redhat.com>
Cc: linux-media@vger.kernel.org
Subject: Re: [PATCH] gspca_stv06xx: enable button found on some Quickcam
 Express variant
Message-Id: <20141028153941.8298e540ddf03796246c6f26@ao2.it>
In-Reply-To: <53C3B0AD.7070001@redhat.com>
References: <1405083417-20615-1-git-send-email-ao2@ao2.it>
	<53C3B0AD.7070001@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, 14 Jul 2014 12:27:57 +0200
Hans de Goede <hdegoede@redhat.com> wrote:

> Hi,
> 
> On 07/11/2014 02:56 PM, Antonio Ospite wrote:
> > Signed-off-by: Antonio Ospite <ao2@ao2.it>
> 
> Thanks, I've added this to my tree and send a pull-req for it
> to Mauro.
>

Hi Hans, I still don't see the change in 3.18-rc2, maybe it got lost.

Here is the patchwork link in case you want to pick the change for 3.19:
https://patchwork.linuxtv.org/patch/24732/

Thanks,
   Antonio

> Regards,
> 
> Hans
> 
> > ---
> >  drivers/media/usb/gspca/stv06xx/stv06xx.c | 4 ++--
> >  1 file changed, 2 insertions(+), 2 deletions(-)
> > 
> > diff --git a/drivers/media/usb/gspca/stv06xx/stv06xx.c b/drivers/media/usb/gspca/stv06xx/stv06xx.c
> > index 49d209b..6ac93d8 100644
> > --- a/drivers/media/usb/gspca/stv06xx/stv06xx.c
> > +++ b/drivers/media/usb/gspca/stv06xx/stv06xx.c
> > @@ -505,13 +505,13 @@ static int sd_int_pkt_scan(struct gspca_dev *gspca_dev,
> >  {
> >  	int ret = -EINVAL;
> >  
> > -	if (len == 1 && data[0] == 0x80) {
> > +	if (len == 1 && (data[0] == 0x80 || data[0] == 0x10)) {
> >  		input_report_key(gspca_dev->input_dev, KEY_CAMERA, 1);
> >  		input_sync(gspca_dev->input_dev);
> >  		ret = 0;
> >  	}
> >  
> > -	if (len == 1 && data[0] == 0x88) {
> > +	if (len == 1 && (data[0] == 0x88 || data[0] == 0x11)) {
> >  		input_report_key(gspca_dev->input_dev, KEY_CAMERA, 0);
> >  		input_sync(gspca_dev->input_dev);
> >  		ret = 0;
> > 


-- 
Antonio Ospite
http://ao2.it

A: Because it messes up the order in which people normally read text.
   See http://en.wikipedia.org/wiki/Posting_style
Q: Why is top-posting such a bad thing?

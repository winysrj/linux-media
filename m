Return-path: <linux-media-owner@vger.kernel.org>
Received: from cdptpa-omtalb.mail.rr.com ([75.180.132.123]:44868 "EHLO
	cdptpa-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753383AbZCaSep (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 31 Mar 2009 14:34:45 -0400
Received: from abadon.pezed.lan ([76.177.10.171])
          by cdptpa-omta02.mail.rr.com with ESMTP
          id <20090331183442.VLTR5830.cdptpa-omta02.mail.rr.com@abadon.pezed.lan>
          for <linux-media@vger.kernel.org>;
          Tue, 31 Mar 2009 18:34:42 +0000
From: Mark Stocker <mark@ale8.org>
To: linux-media@vger.kernel.org
Subject: Re: Wintv-1250 - EEPROM decoding - V4L DVB
Date: Tue, 31 Mar 2009 14:34:41 -0400
References: <49CFC642.3030408@videotron.ca> <49CFFECB.4080902@linuxtv.org>
In-Reply-To: <49CFFECB.4080902@linuxtv.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200903311434.41411.mark@ale8.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I have implemented this same change and found this eeprom offset works 
correctly on my HVR-1250 as well.  Not that it really helps anything at this 
point.  Is there a datasheet available to the public for this chipset?



On Sunday March 29 2009 7:05:47 pm Steven Toth wrote:
> >        switch (dev->board) {
> > /* removed        case CX23885_BOARD_HAUPPAUGE_HVR1250: */
> >        case CX23885_BOARD_HAUPPAUGE_HVR1500:
> >        case CX23885_BOARD_HAUPPAUGE_HVR1500Q:
> >        case CX23885_BOARD_HAUPPAUGE_HVR1400:
> >                if (dev->i2c_bus[0].i2c_rc == 0)
> >                        hauppauge_eeprom(dev, eeprom+0x80);
> >                break;
> >        case CX23885_BOARD_HAUPPAUGE_HVR1250: /*added*/
> >        case CX23885_BOARD_HAUPPAUGE_HVR1800:
> >        case CX23885_BOARD_HAUPPAUGE_HVR1800lp:
> >        case CX23885_BOARD_HAUPPAUGE_HVR1200:
> >        case CX23885_BOARD_HAUPPAUGE_HVR1700:
> >                if (dev->i2c_bus[0].i2c_rc == 0)
> >                        hauppauge_eeprom(dev, eeprom+0xc0);
> >                break;
> >        }
>
> Thanks.
>
> Hauppauge have various revs of the 1250 and the eeprom offset can change.
> It looks like your model is different the the stock HVR-1250 I've seen.
>
> - Steve
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



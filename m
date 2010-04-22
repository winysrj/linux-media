Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.prodrive.nl ([194.151.106.228]:16565 "EHLO
	mail.prodrive.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755748Ab0DVPfd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 22 Apr 2010 11:35:33 -0400
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: switching DVB-C DVB-T on frontend using DVB API V5
Date: Thu, 22 Apr 2010 17:23:57 +0200
Message-ID: <4CD35CD1F8085945B597F80EEC8942130480953B@exc01.bk.prodrive.nl>
From: "Rob van de Voort" <rob.van.der.voort@Prodrive.nl>
To: <linux-media@vger.kernel.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

I'm trying to develop a DVB frontend adapter driver using the DVB API
V5. 
I found updated documentation on
http://carfax.org.uk/kdoc/media/pt02.html

-1- Is there another place were up to date documentation for API V5 is
available because I couldn't find it on LinuxTv.org

-2- The frontend chipset of the card supports DVB-C, DVB-T. Can the DVB
API be used to switch the chip from DVB-T to DVB-C and vice versa. Can
this be done with FE_SET_PROPERTY and DTV_DELIVERY_SYSTEM? 

How is writing this property (DTV_DELIVERY_SYSTEM) handled in the
kernel?

DTV_DELIVERY_SYSTEM: Read the type of delivery system. Values are
defined in fe_delivery_system_t. It is not clear what the effect of
writing this property is.  

Thanks in advance,

Regards,

Rob van de Voort

    


Disclaimer: The information contained in this email, including any attachments is 
confidential and is for the sole use of the intended recipient(s). Any unauthorized 
review, use, disclosure or distribution is prohibited. If you are not the intended 
recipient, please notify the sender immediately by replying to this message and 
destroy all copies of this message and any attachments.

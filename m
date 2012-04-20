Return-path: <linux-media-owner@vger.kernel.org>
Received: from ducmta03.flextronics.com ([158.116.236.189]:65278 "EHLO
	ducmta03.flextronics.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753318Ab2DTKLk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 20 Apr 2012 06:11:40 -0400
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
content-transfer-encoding: 8BIT
Subject: Mipi csi2 driver for Omap4
Date: Fri, 20 Apr 2012 12:11:38 +0200
Message-ID: <414D8776B339BF44ADF9839A98A591A0046B8C63@EUDUCEX3.europe.ad.flextronics.com>
From: "Steve Lindell" <Steve.Lindell@se.flextronics.com>
To: <linux-media@vger.kernel.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi!
I'm developing a mipi csi2 receiver for test purpose and need some help of how to capture the data stream from a camera module.
I'm using a phytec board with a Omap4430 processor running Linux 
kernel 3.0.9. Connected to the MIPI lanes I have a camera module (soled on a flexfilm) 
The camera follows the Mipi csi2 specs and is controlled via an external I2C controller.
I have activated the camera and its now transmitting a test pattern on the Mipi lines (4 line connection).

I need to capture the stream and store it as a Raw Bayer snapshot.
Is this possible use Omap4430 and does Linux have the necessary drivers to capture the stream.
If this driver exists are there any documentation of how to implement the driver?

Is it possible to get some help of how to get started?


Appreciate any help I could get.

BR

Steve Lindell
Test Developer
Creating value that increases customer competitiveness    
Datalinjen 5
Box 1568
SE-581 15 Linköping
 
+46 13 287031     direct
+46 709 652396   mobile
+46 13 28 70 99   fax

steve.lindell@se.flextronics.com     I     www.flextronics.com 



  
Legal Disclaimer:
The information contained in this message may be privileged and confidential. It is intended to be read only by the individual or entity to whom it is addressed or by their designee. If the reader of this message is not the intended recipient, you are on notice that any distribution of this message, in any form, is strictly prohibited. If you have received this message in error, please immediately notify the sender and delete or destroy any copy of this message

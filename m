Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailrelay009.isp.belgacom.be ([195.238.6.176]:50535 "EHLO
	mailrelay009.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751809AbZDOJok (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 15 Apr 2009 05:44:40 -0400
From: Laurent Pinchart <laurent.pinchart@skynet.be>
To: Douglas Schilling Landgraf <dougsland@gmail.com>
Subject: Re: [PATCH] uvc: Add Microsoft VX 500 webcam
Date: Wed, 15 Apr 2009 11:46:52 +0200
Cc: linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@infradead.org>
References: <68cac7520904150003n150bff9bp616cc49e684d947d@mail.gmail.com>
In-Reply-To: <68cac7520904150003n150bff9bp616cc49e684d947d@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200904151146.52459.laurent.pinchart@skynet.be>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Douglas,

On Wednesday 15 April 2009 09:03:45 Douglas Schilling Landgraf wrote:
> Hello Laurent,
>
>     Attached patch for the following:
>
>     Added Microsoft VX 500 webcam to uvc driver.
>
> Signed-off-by: Douglas Schilling Landgraf <dougsland@redhat.com>

Could you please send me the output of

lsusb -v -d 045e:074a

using usbutils 0.72 or newer (0.73+ preferred) ?

Have you tried the latest driver ? The MINMAX quirk isn't required anymore for 
most cameras (although the two supported Microsoft webcams still need it, so I 
doubt it will work as-is).

Best regards,

Laurent Pinchart


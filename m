Return-path: <mchehab@pedra>
Received: from mailfe06.c2i.net ([212.247.154.162]:37372 "EHLO swip.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750829Ab1FPIHF (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 16 Jun 2011 04:07:05 -0400
From: Hans Petter Selasky <hselasky@c2i.net>
To: Jiri Slaby <jirislaby@gmail.com>
Subject: Re: DVB_NET help message is useless
Date: Thu, 16 Jun 2011 10:05:37 +0200
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
References: <4DF9AB93.1040903@gmail.com>
In-Reply-To: <4DF9AB93.1040903@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Message-Id: <201106161005.37542.hselasky@c2i.net>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Thursday 16 June 2011 09:06:59 Jiri Slaby wrote:
> I would send a patch, but I really have no idea what's that good for.

DVB network support is referring to the IP stack. This option is set to "N" 
when compiling the Linux DVB stack on systems without IP networking.

Please submit a patch if you need a better description.

--HPS

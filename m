Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:35888 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755182AbaGUQYN (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 21 Jul 2014 12:24:13 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Michael Durkin <kc7noa@gmail.com>
Cc: linux-media@vger.kernel.org
Subject: Re: Fresco Logic FL2000
Date: Mon, 21 Jul 2014 18:24:24 +0200
Message-ID: <3072133.WlkirvIpIB@avalon>
In-Reply-To: <CAC8M0Evra8ipDo9Tgasd2AtWWLZQ8M2Ty37i6R3nc7H0-C3_wg@mail.gmail.com>
References: <CAC8M0Evra8ipDo9Tgasd2AtWWLZQ8M2Ty37i6R3nc7H0-C3_wg@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Michael,

On Tuesday 20 May 2014 18:32:08 Michael Durkin wrote:
> It was suggested to me to inquire here if anyone was working on
> drivers or support for the Fresco Logic FL2000 1d5c:2000

Could you please post the output of

lsusb -v -d 1d5c:2000

(if possible running as root) ?

-- 
Regards,

Laurent Pinchart


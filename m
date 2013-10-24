Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.21]:61883 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755292Ab3JXQy3 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 24 Oct 2013 12:54:29 -0400
Received: from [192.168.1.56] ([84.26.254.29]) by mail.gmx.com (mrgmx002)
 with ESMTPSA (Nemesis) id 0LfBX6-1W29Mq0qOO-00opLK for
 <linux-media@vger.kernel.org>; Thu, 24 Oct 2013 18:54:28 +0200
Message-ID: <52695106.8020705@gmx.net>
Date: Thu, 24 Oct 2013 18:55:34 +0200
From: "P. van Gaans" <w3ird_n3rd@gmx.net>
MIME-Version: 1.0
To: Tobias Bengtsson <tjolle@gmail.com>
CC: linux-media@vger.kernel.org
Subject: Re: Terratec H5 (analog support)
References: <CAAZmLNdKzHb-hqcjeE7=YZ=0Y3OW67BGrbMMS59LQAaRmfRz9Q@mail.gmail.com>
In-Reply-To: <CAAZmLNdKzHb-hqcjeE7=YZ=0Y3OW67BGrbMMS59LQAaRmfRz9Q@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 10/24/2013 04:26 PM, Tobias Bengtsson wrote:
> Hi!
>
> I'm trying this question again. DVB-C works perfectly with the
> V4L-driver, but I'm a bit curious if the analog tuner is supposed to
> be supported? A video0 device gets created but starting tvheadend it
> complains about it missing a tuner and the device is skipped. Is this
> an issue with tvheadend or a constraint of the driver?
>
> Thanks in advance.
>

Hi Tobias,

To my knowledge, the driver does not support analog in any way.

Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:51552 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751601Ab2AZSRA (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 26 Jan 2012 13:17:00 -0500
Message-ID: <4F21989A.9080300@iki.fi>
Date: Thu, 26 Jan 2012 20:16:58 +0200
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Claus Olesen <ceolesen@gmail.com>
CC: linux-media@vger.kernel.org
Subject: Re: 290e locking issue
References: <CAGa-wNOCn6GDu0DGM7xNrVagp0sdNeif25vuE+sPyU3aaegGAw@mail.gmail.com>	<4F2117D6.20702@iki.fi>	<CAGa-wNNnaJbrLdAGA9cX=wMBwZYtVp8JLseeTGevDJH-tyDpeQ@mail.gmail.com>	<4F213FEF.8030309@iki.fi> <CAGa-wNO5GihQcxBF88yXC7B=PO3upw-pN5YGzJ5Rm_+Sji9iBg@mail.gmail.com>
In-Reply-To: <CAGa-wNO5GihQcxBF88yXC7B=PO3upw-pN5YGzJ5Rm_+Sji9iBg@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 01/26/2012 07:09 PM, Claus Olesen wrote:
> the behavior with the latest media_build.git is the same as that which
> was with fedora stock.

After all I am almost 100% sure it is em28xx (USB-interface driver used) 
or/and USB-bus related issue. Likely it will happen for other em28xx 
devices too. But as I do not have enough knowledge about that area I 
cannot do much for fixing it. Maybe it is better try to avoid using 
those devices same time and try use USB-hub, other USB-port, add new 
USB-controller, etc...


regards
Antti
-- 
http://palosaari.fi/

Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ew0-f228.google.com ([209.85.219.228]:57467 "EHLO
	mail-ew0-f228.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750755Ab0A3Pnc (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 30 Jan 2010 10:43:32 -0500
Received: by ewy28 with SMTP id 28so542965ewy.28
        for <linux-media@vger.kernel.org>; Sat, 30 Jan 2010 07:43:30 -0800 (PST)
Message-ID: <4B645397.4030404@gmail.com>
Date: Sat, 30 Jan 2010 16:43:19 +0100
From: Martin Fuzzey <mfuzzey@gmail.com>
Reply-To: mfuzzey@gmail.com
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>
CC: Jef Treece <treecej@comcast.net>, linux-media@vger.kernel.org
Subject: Re: fix regression in pwc_set_shutter_speed???
References: <20100129011734.GA10096@kroah.com> <1351307599.538561264809789383.JavaMail.root@sz0171a.emeryville.ca.mail.comcast.net> <20100130052312.GA22196@kroah.com>
In-Reply-To: <20100130052312.GA22196@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Greg KH wrote:
> Video developers, any comments?
>
> Jef, were you able to narrow it down to the actual patch that caused the
> problem.
>
>   
Indeed it was my commit 6b35ca0d3d586b8ecb8396821af21186e20afaf0

I somehow missed the email from Laurent back in August about this.

Am checking the rest of that commit now and will send a fix patch soon.

Sorry about that.

Martin


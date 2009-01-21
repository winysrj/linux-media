Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp3-g21.free.fr ([212.27.42.3]:41747 "EHLO smtp3-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752584AbZAUSju (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 21 Jan 2009 13:39:50 -0500
Received: from smtp3-g21.free.fr (localhost [127.0.0.1])
	by smtp3-g21.free.fr (Postfix) with ESMTP id B3AE481810D
	for <linux-media@vger.kernel.org>; Wed, 21 Jan 2009 19:39:44 +0100 (CET)
Received: from localhost (lns-bzn-57-82-249-43-204.adsl.proxad.net [82.249.43.204])
	by smtp3-g21.free.fr (Postfix) with ESMTP id A264181829B
	for <linux-media@vger.kernel.org>; Wed, 21 Jan 2009 19:39:41 +0100 (CET)
Date: Wed, 21 Jan 2009 19:34:34 +0100
From: Jean-Francois Moine <moinejf@free.fr>
To: linux-media@vger.kernel.org
Subject: Re: [PATCH 3/5] gspca: use usb_make_path to report bus info
Message-ID: <20090121193434.5cb7c184@free.fr>
In-Reply-To: <497644D6.7060102@free.fr>
References: <49764412.8030305@free.fr>
	<497644D6.7060102@free.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, 20 Jan 2009 22:40:38 +0100
Thierry Merle <thierry.merle@free.fr> wrote:

> usb_make_path reports canonical bus info. Use it when reporting bus
> info in VIDIOC_QUERYCAP.
> 
> Signed-off-by: Thierry MERLE <thierry.merle@free.fr>

Applied. Thanks.

-- 
Ken ar c'hentañ	|	      ** Breizh ha Linux atav! **
Jef		|		http://moinejf.free.fr/

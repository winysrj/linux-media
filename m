Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp1-g21.free.fr ([212.27.42.1]:57066 "EHLO smtp1-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752666AbZEZTJr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 26 May 2009 15:09:47 -0400
Received: from smtp1-g21.free.fr (localhost [127.0.0.1])
	by smtp1-g21.free.fr (Postfix) with ESMTP id 91B6E9401EF
	for <linux-media@vger.kernel.org>; Tue, 26 May 2009 21:09:42 +0200 (CEST)
Received: from gandalf.hd.free.fr (wmh38-1-82-225-140-65.fbx.proxad.net [82.225.140.65])
	by smtp1-g21.free.fr (Postfix) with ESMTP id 9A75B940132
	for <linux-media@vger.kernel.org>; Tue, 26 May 2009 21:09:40 +0200 (CEST)
Received: from localhost
	([127.0.0.1] helo=gandalf.localnet ident=domi)
	by gandalf.hd.free.fr with esmtp (Exim 4.69)
	(envelope-from <domi.dumont@free.fr>)
	id 1M921r-0003Hj-GT
	for linux-media@vger.kernel.org; Tue, 26 May 2009 21:09:39 +0200
From: Dominique Dumont <domi.dumont@free.fr>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Date: Tue, 26 May 2009 21:09:38 +0200
References: <200905252211.50393.domi.dumont@free.fr>
In-Reply-To: <200905252211.50393.domi.dumont@free.fr>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200905262109.39176.domi.dumont@free.fr>
Subject: Re: dvb_usb_nova_t_usb2: firmware is loaded too late
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Le Monday 25 May 2009 22:11:49 Dominique Dumont, vous avez écrit :
> I have some trouble with the initialisation of dvb_usb_nova_t_usb2: the
> firmware is loaded about 1 minute after the module is registered by
> usbcore:

Sorry, I forgot to mention my kernel version 2.6.29.3 (Debian/sid amd64 
kernel)

I did not have any loading problem with 2.6.28, the issue appeared only with 
2.6.29.

HTH


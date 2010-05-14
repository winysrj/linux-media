Return-path: <linux-media-owner@vger.kernel.org>
Received: from impaqm1.telefonica.net ([213.4.138.1]:44440 "EHLO
	IMPaqm1.telefonica.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752638Ab0ENAud convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 13 May 2010 20:50:33 -0400
From: Jose Alberto Reguero <jareguero@telefonica.net>
To: Antti Palosaari <crope@iki.fi>
Subject: Re: AF9015 suspend problem
Date: Fri, 14 May 2010 02:50:30 +0200
Cc: linux-media@vger.kernel.org
References: <201005021739.18393.jareguero@telefonica.net> <4BEC70FB.5030002@iki.fi>
In-Reply-To: <4BEC70FB.5030002@iki.fi>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Message-Id: <201005140250.30481.jareguero@telefonica.net>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

El Jueves, 13 de Mayo de 2010, Antti Palosaari escribió:
> Terve!
> 
> On 05/02/2010 06:39 PM, Jose Alberto Reguero wrote:
> > When I have a af9015 DVB-T stick plugged I can not recover from pc
> > suspend. I must unplug the stick to suspend work. Even if I remove the
> > modules I cannot recover from suspend.
> > Any idea why this happen?
> 
> Did you asked this 7 months ago from me?
> I did some tests (http://linuxtv.org/hg/~anttip/suspend/) and looks like
> it is firmware loader problem (fw loader misses something or like
> that...). No one answered when I asked that from ML, but few weeks ago I
> saw some discussion. Look ML archives.
> 
> regards
> Antti

I think that is another problem. If I blacklist the af9015 driver and have the 
stick plugged in, the suspend don't finish, and the system can't resume. If I 
unplugg the stick the suspend feature work well.

Jose Alberto

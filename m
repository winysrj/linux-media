Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:58922 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751581Ab0EDBgo (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 3 May 2010 21:36:44 -0400
Message-ID: <4BDF7A27.7000907@redhat.com>
Date: Mon, 03 May 2010 22:36:39 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Bee Hock Goh <beehock@gmail.com>
CC: "linux-media >> Linux Media Mailing List"
	<linux-media@vger.kernel.org>
Subject: Re: [PATCH] Fix colorspace on tm6010
References: <4BDE7DB4.7030706@redhat.com>	 <k2y6e8e83e21005030113v64aea6c0q87754a5d8f04d2d4@mail.gmail.com>	 <4BDF60AB.8020600@redhat.com> <g2j6e8e83e21005031744s429fdbe7g1a106e13949ad33c@mail.gmail.com>
In-Reply-To: <g2j6e8e83e21005031744s429fdbe7g1a106e13949ad33c@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Bee Hock Goh wrote:
> Its too much time to fix it so I simply reinstall the OS but I will be
> working with hg tree for the time being.
> 
> True but having the audio will probably help to ascertain how bad the
> frame loss is. And also writing the audio module will be trivial to
> you but it will take some time for me.

I never said it is fast ;) The first alsa driver at v4l-dvb took a long time,
but, after having the first, the others are (almost) cut-and-paste stuff,
plus some time to debug.

-- 

Cheers,
Mauro

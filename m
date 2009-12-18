Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp3-g21.free.fr ([212.27.42.3]:51042 "EHLO smtp3-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753261AbZLRTNY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 18 Dec 2009 14:13:24 -0500
Date: Fri, 18 Dec 2009 20:13:49 +0100
From: Jean-Francois Moine <moinejf@free.fr>
To: Nicolau Werneck <nwerneck@gmail.com>
Cc: linux-media@vger.kernel.org
Subject: Re: patch to support for 0x0802 sensor in t613.c
Message-ID: <20091218201349.69ca27a5@tele>
In-Reply-To: <20091218184604.GA24444@pathfinder.pcs.usp.br>
References: <20091218184604.GA24444@pathfinder.pcs.usp.br>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, 18 Dec 2009 16:46:04 -0200
Nicolau Werneck <nwerneck@gmail.com> wrote:

> Hello. I am a clueless n00b, and I can't make patches or use any
> proper development tools. But I made this modification to t613.c to
> support this new sensor. It is working fine with me. I just cleaned
> the code up a bit and compiled and tested with the 2.6.32 kernel, and
> it seems to be working fine.
> 
> If somebody could help me creating a proper patch to submit to the
> source tree, I would be most grateful. The code is attached.

Hello Nicolau,

Your code seems fine. To create a patch, just go to the linux tree
root, make a 'diff -u' from the original file to your new t613.c, edit
it, at the head, add a comment and a 'Signed-off-by: <your email>', and
submit to the mailing-list with subject '[PATCH] gspca - t613: Add new
sensor lt168g'.

BTW, as you know the name of your sensor, do you know the real name of
the sensor '0x803' ('other')? (it should be in some xxx.ini file in a
ms-win driver, but I could not find it - the table n4_other of t613.c
should be a table 'Regxxx' in the xx.ini)

Best regards.

-- 
Ken ar c'hentañ	|	      ** Breizh ha Linux atav! **
Jef		|		http://moinejf.free.fr/

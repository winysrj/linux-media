Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp3-g21.free.fr ([212.27.42.3]:60396 "EHLO smtp3-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752452Ab0C0JXQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 27 Mar 2010 05:23:16 -0400
Date: Sat, 27 Mar 2010 10:23:58 +0100
From: Jean-Francois Moine <moinejf@free.fr>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: linux-media@vger.kernel.org
Subject: Problem with GIT 30b8f0787e51a3ab0c447e0e3bf4aadc7caf9ffd
Message-ID: <20100327102358.696c5e4b@tele>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

Your change

	V4L/DVB: gspca: fixes compilation when input is not selected

does not work: when CONFIG_INPUT is not set, the macros gspca_input_xxx
are not defined, and the compilation fails.


Cheers.

-- 
Ken ar c'hentañ	|	      ** Breizh ha Linux atav! **
Jef		|		http://moinejf.free.fr/

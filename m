Return-path: <linux-media-owner@vger.kernel.org>
Received: from up.free-electrons.com ([94.23.35.102]:54876 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751305Ab3HAQgb (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 1 Aug 2013 12:36:31 -0400
Date: Thu, 1 Aug 2013 13:36:25 -0300
From: Ezequiel Garcia <ezequiel.garcia@free-electrons.com>
To: Luis Polasek <pola@sol.info.unlp.edu.ar>
Cc: linux-media@vger.kernel.org,
	"jbucar@lifia.info.unlp.edu.ar" <jbucar@lifia.info.unlp.edu.ar>,
	Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: Re: Fwd: dib8000 scanning not working on 3.10.3
Message-ID: <20130801163624.GA10498@localhost>
References: <CAER7dwe+kkVoDbRt9Xj8+77tJnL29bxRzHbSPYOrck_HxVsENw@mail.gmail.com>
 <CAER7dwe8UQZ=5iZhCi1C1-DGi7t_Hz43M4QamnBSNerHNnDCvg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAER7dwe8UQZ=5iZhCi1C1-DGi7t_Hz43M4QamnBSNerHNnDCvg@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Luis,

(I'm Ccing Mauro, who mantains this driver and might know what's going on).

On Wed, Jul 31, 2013 at 03:47:10PM -0300, Luis Polasek wrote:
> Hi, I just upgraded my kernel to 3.10.3, and dib8000 scanning does not
> work anymore.
> 
> I tested using dvbscan (from dvb-apps/util/) and w_scan on a Prolink
> Pixelview SBTVD (dib8000 module*).This tools worked very well on
> version 3.9.9 , but now it does not produces any result, and also
> there are no error messages in the logs (dmesg).
> 

Please run a git bisect and report your findings.

Note that dibcom8000 shows just a handful of commit on 2013,
so you could start reverting those and see what happens.

-- 
Ezequiel García, Free Electrons
Embedded Linux, Kernel and Android Engineering
http://free-electrons.com

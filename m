Return-path: <linux-media-owner@vger.kernel.org>
Received: from top.free-electrons.com ([176.31.233.9]:48810 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751300Ab3LKN1q (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 11 Dec 2013 08:27:46 -0500
Date: Wed, 11 Dec 2013 10:27:52 -0300
From: Ezequiel Garcia <ezequiel.garcia@free-electrons.com>
To: Javier =?utf-8?B?QsO6Y2Fy?= <jbucar@lifia.info.unlp.edu.ar>
Cc: Luis Polasek <pola@sol.info.unlp.edu.ar>,
	linux-media@vger.kernel.org
Subject: Re: Fwd: dib8000 scanning not working on 3.10.3
Message-ID: <20131211132751.GA3288@localhost>
References: <CAER7dwe+kkVoDbRt9Xj8+77tJnL29bxRzHbSPYOrck_HxVsENw@mail.gmail.com>
 <CAER7dwe8UQZ=5iZhCi1C1-DGi7t_Hz43M4QamnBSNerHNnDCvg@mail.gmail.com>
 <20131210183812.GA3546@localhost>
 <CAJmEX9Cxrm=8FdDAWngNA=v1j8idqcMYtNcNxByGKUNdMk95JA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAJmEX9Cxrm=8FdDAWngNA=v1j8idqcMYtNcNxByGKUNdMk95JA@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Javier,

On Tue, Dec 10, 2013 at 04:46:16PM -0200, Javier Búcar wrote:
> 
> The issue remain on kernel 3.12.3

I'll try to push a fixed kernel (with some patches reverted), so you can
try.

Will you be able to try a mainline-like kernel? I'll push a git branch,
so it'll be something like this:

  git://git.free-electrons.com/users/ezequiel-garcia/linux/

It won't happen anytime soon, but I'll try to do it before the end of
the year.
-- 
Ezequiel García, Free Electrons
Embedded Linux, Kernel and Android Engineering
http://free-electrons.com

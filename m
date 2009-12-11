Return-path: <linux-media-owner@vger.kernel.org>
Received: from rcsinet12.oracle.com ([148.87.113.124]:39469 "EHLO
	rcsinet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752862AbZLKRg4 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 11 Dec 2009 12:36:56 -0500
Date: Fri, 11 Dec 2009 09:36:37 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>,
	linux-media@vger.kernel.org
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: Tree for December 11 (media/dvb/frontends)
Message-Id: <20091211093637.be0b6584.randy.dunlap@oracle.com>
In-Reply-To: <20091211160151.6b71078e.sfr@canb.auug.org.au>
References: <20091211160151.6b71078e.sfr@canb.auug.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, 11 Dec 2009 16:01:51 +1100 Stephen Rothwell wrote:

> Hi all,
> 
> My usual call for calm: please do not put stuff destined for 2.6.34 into
> linux-next trees until after 2.6.33-rc1.
> 
> Changes since 20091210:


drivers/media/dvb/frontends/dib0090.h:103: error: expected '=', ',', ';', 'asm' or '__attribute__' before 'frontend_tune_state'

static inline num frontend_tune_state dib0090_get_tune_state(struct dvb_frontend *fe)

s/num/enum/

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

drivers/media/dvb/frontends/dib8000.h:104: error: expected expression before '}' token
drivers/media/dvb/frontends/dib8000.h:104: warning: left-hand operand of comma expression has no effect

    return CT_SHUTDOWN,

s/,/;/
and use tab to indent.



someone built/tested these??

---
~Randy

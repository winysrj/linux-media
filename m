Return-path: <mchehab@pedra>
Received: from mailout-de.gmx.net ([213.165.64.22]:36471 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1753150Ab1AKBXI (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 10 Jan 2011 20:23:08 -0500
From: Oliver Endriss <o.endriss@gmx.de>
Reply-To: linux-media@vger.kernel.org
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: Re: Debug code in HG repositories
Date: Tue, 11 Jan 2011 02:10:48 +0100
Cc: linux-media@vger.kernel.org, Hans Verkuil <hverkuil@xs4all.nl>,
	Devin Heitmueller <dheitmueller@kernellabs.com>
References: <201101072053.37211@orion.escape-edv.de> <201101080056.40803@orion.escape-edv.de> <4D2AF5E6.1070007@redhat.com>
In-Reply-To: <4D2AF5E6.1070007@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201101110210.49205@orion.escape-edv.de>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Monday 10 January 2011 13:04:54 Mauro Carvalho Chehab wrote:
> Em 07-01-2011 21:56, Oliver Endriss escreveu:
> > ...
> > There are large pieces of driver code which are currently unused, and
> > nobody can tell whether they will ever be needed.
> > 
> > On the other hand a developer spent days writing this stuff, and now it
> > does not exist anymore - without any trace!
> > 
> > The problem is not, that it is missing in the current snapshot, but
> > that it has never been in the git repository, and there is no way to
> > recover it.
> 
> The Mercurial tree will stay there forever. We still have there the old CVS 
> trees used by DVB and V4L development.
> > 
> > Afaics, the only way to preserve this kind of code is 'out-of-tree'.
> > It is a shame... :-(
> 
> I see your point. It is harder for people to re-use that code, as they are not
> upstream.

The main problem is that they do not even know that the code exists.

Maybe I should add some comment to the driver, that someone should look
into the HG repository, before he starts re-inventing the wheel.

> It is easy to recover the changes with:
> 
> $ gentree.pl 2.6.37 --strip_dead_code linux/ /tmp/stripped
> $ gentree.pl 2.6.37  linux/ /tmp/not_stripped
> $ diff -upr /tmp/stripped/ /tmp/not_stripped/ >/tmp/revert_removed_code.patch
> 
> As a reference and further discussions, I'm enclosing the diff.

The resulting diff is far from complete.
In fact, the most interesting parts are missing.

Apparently, the command
    gentree.pl 2.6.37  linux/ /tmp/not_stripped
stripped all '#if 0' blocks, which are not followed by a comment.
Just compare the original ngene_av.c with the resulting version in
/tmp/non_stripped.

CU
Oliver

-- 
----------------------------------------------------------------
VDR Remote Plugin 0.4.0: http://www.escape-edv.de/endriss/vdr/
4 MByte Mod: http://www.escape-edv.de/endriss/dvb-mem-mod/
Full-TS Mod: http://www.escape-edv.de/endriss/dvb-full-ts-mod/
----------------------------------------------------------------

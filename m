Return-path: <video4linux-list-bounces@redhat.com>
Date: Sun, 4 Jan 2009 22:50:22 -0200
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Message-ID: <20090104225022.0e8c3eb7@pedra.chehab.org>
In-Reply-To: <Pine.LNX.4.64.0812171914550.8733@axis700.grange>
References: <Pine.LNX.4.64.0812171914550.8733@axis700.grange>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: video4linux-list@redhat.com,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: "patches can be modified..."
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <linux-media.vger.kernel.org>

On Thu, 1 Jan 2009 12:52:09 +0100 (CET)
Guennadi Liakhovetski <g.liakhovetski@gmx.de> wrote:

> Hi all,
> 
> everyone who has once got his or her patch committed to v4l received an 
> auto-reply
> 
> From: Patch added by Xxxxx Xxxxx <hg-commit@linuxtv.org>
> To: linuxtv-commits@linuxtv.org
> 
> with a comment:
> 
(text moved to the end, to make easier for me to comment)
>
> What does this mean? Does the last sentence refer to "patches may be 
> modified" or to "patch was added"? And why should objections against 
> either of them be sent to the maintainer instead of being discussed on the 
> list? Don't understand. Does it mean that if a specific author has 
> objections, the respective driver can be left off from the 
> backwards-compatibility conversions?

This message is there to advice that:

> <quote>
> The patch number NNNN was added via name <user@provider.com>
> to http://linuxtv.org/hg/v4l-dvb master development tree.

1) The patch were accepted by the maintainer and are at the tree for testing purposes;

> Kernel patches in this development tree may be modified to be backward
> compatible with older kernels. Compatibility modifications will be
> removed before inclusion into the mainstream Kernel

2) on a few cases where:
  a) the patch was generated against -git tree and needs some compat code to
    compile on -hg, or 
  b) the patch adds some compat code
This warns that the compat code will be removed by ./v4l/scripts/gentree.pl
script when generating the -git patch;

> If anyone has any objections, please let us know by sending a message to:
> 	v4l-dvb-maintainer@linuxtv.org
> </quote>

3) People may review the patch (since the -hg tree is just a staging tree).

Btw, the email need to change, since it should use 
	Linux Media Mailing List <linux-media@vger.kernel.org>

Instead of the previous one.

Cheers,
Mauro

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list

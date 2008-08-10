Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Message-ID: <489F2B71.4060607@linuxtv.org>
Date: Sun, 10 Aug 2008 13:54:57 -0400
From: Michael Krufky <mkrufky@linuxtv.org>
MIME-Version: 1.0
To: Anton Blanchard <anton@samba.org>
References: <20080804131051.GA7241@kryten>
	<37219a840808040935o3cf613bdvd644bb0e592c8430@mail.gmail.com>
	<20080809041847.GA5045@kryten>
In-Reply-To: <20080809041847.GA5045@kryten>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] [PATCH] DViCO FusionHDTV DVB-T Dual Digital 4 (rev
	2)
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

Anton Blanchard wrote:
> Add support for revision 2 of the DViCO FusionHDTV DVB-T Dual Digital 4
> which has new tuners and demodulators (2 x DIB7070p). With this patch
> both DVB reception and IR works.
>
> The dib7000p driver currently hardwires the output mode to
> OUTMODE_MPEG2_SERIAL regardless of what we ask for. Modify it to allow
> OUTMODE_MPEG2_PAR_GATED_CLK to be set. Longer term we should remove the
> check completely and set the output mode correctly in all the callers.
>
> Add Kconfig bits to ensure the dib7000p and dib0070 modules are enabled.
> It would be nice to only do this for the !DVB_FE_CUSTOMISE case, but
> this is what the other DIB7070 module does (there are a number of
> module dependencies in the attach code).
>
> Signed-off-by: Anton Blanchard <anton@samba.org>
Anton,

I've applied your patch to my cxusb tree, with slight modifications. 
Please test the tree and confirm proper operation before I request a
merge into the master branch.

http://linuxtv.org/hg/~mkrufky/cxusb

You'll notice that I fixed the dib0070.h and dib7000p.h headers to allow
cxusb the option of using DVB_FE_CUSTOMIZE, but when these modules are
selected, dvb-usb-cxusb is still static linked to them.

Perhaps we could put all of the dib7070p common setup into a dib7070p
module, to centralize the duplicated code between dib0700 and cxusb. 
This could also help to remove the static links described above.

I started playing around with this idea -- If I make any progress, I'll
post the tree and ask for testers.

I don't think that the static links are enough of a reason to hold this
patch back from a merge.  Hopefully we can find a solution before
2.6.28, but if we don't , it's no real harm done.

If you have any additional fixes / changes to make before this is merged
into master, please generate them against this cxusb tree.

Regards,

Mike



_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb

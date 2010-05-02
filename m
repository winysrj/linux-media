Return-path: <linux-media-owner@vger.kernel.org>
Received: from lo.gmane.org ([80.91.229.12]:46467 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755580Ab0EBNZI (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 2 May 2010 09:25:08 -0400
Received: from list by lo.gmane.org with local (Exim 4.69)
	(envelope-from <gldv-linux-media@m.gmane.org>)
	id 1O8ZAN-0000c9-Kq
	for linux-media@vger.kernel.org; Sun, 02 May 2010 15:25:03 +0200
Received: from gimpelevich.san-francisco.ca.us ([66.218.54.163])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-media@vger.kernel.org>; Sun, 02 May 2010 15:25:03 +0200
Received: from daniel by gimpelevich.san-francisco.ca.us with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-media@vger.kernel.org>; Sun, 02 May 2010 15:25:03 +0200
To: linux-media@vger.kernel.org
From: Daniel Gimpelevich <daniel@gimpelevich.san-francisco.ca.us>
Subject: Re: Reponse from Geniatech Re: X8000A and KWorld ATSC 120
Date: Sun, 2 May 2010 13:14:29 +0000 (UTC)
Message-ID: <hrjtrk$d21$1@dough.gmane.org>
References: <200904131742.17404.vanessaezekowitz@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

In the past year and a half, my personal life took turns for the crazier 
and crazier. some time prior to that, I had near perfect support working 
for all functions of this card, including IR, but it never made it into 
mercurial due to a disagreement with Mauro about what I saw as 
fundamental changes needed to the cx88 driver design. However, this 
vendor support offer has my attention for a different reason: Having 
successfully added support for the AVerMedia Volar A868R, I've been asked 
to see what I can do about Geniatech's MyGica A680B stick. There is 
already a wiki entry on it:
http://www.linuxtv.org/wiki/index.php/Sabrent_TV-USBHD
If what Fang offered for the X8000A he can provide for the A680B, the 
longstanding issues could be resolved regarding this tree:
http://linuxtv.org/hg/~mkrufky/teledongle
Since it has been so long since the quoted message, I thought it best to 
ask this list whether there was any further communication. Has there been?

On Mon, 13 Apr 2009 17:42:17 -0500, Vanessa Ezekowitz wrote:

> Hi all.  As a follow-up to the remote control support issue for the
> Kworld ATSC 120, Geniatech sent me a very encouraging reply today.
> 
> Anyone want to take Fang up on his offer?
> 
> 
> ----------  Forwarded Message  ----------
> 
> Subject: 答复: Technical request regarding the HDTV Thriller X8000A Date:
> Monday 13 April 2009
> From: "Fang" <Fjj@geniatech.com>
> To: "'Vanessa Ezekowitz'" <vanessaezekowitz@gmail.com>
> 
> Dear Vanessa Ezekowitz:
> 
> 
> Thanks for your inquiry.
> 
> My name is Fang, product manager of Geniatech.
> 
> 1st, we can provide you the remote decoder IC information, including I2C
> address, r/w API, it is simple, read I2C address every 150ms, and you
> can get the the key stroke decoding value.
> 
> 2nd, we have step products and both follow this protocol, so it is
> useful for all our products.
> 
> 3rd, we'd like to support you directly from the Geniatech, that card is
> designed by us.
> 
> Finnally,  I'd like to ask you if you can port more linux drivers if we
> send you samples and tech informations for our other 2 ATSC products:
> X8350 and X8550.
> 
> I will send you more detailed tech information to you about the remote
> IC whatever your answer is.
> 
> Best Regards
> Fang
> 
> -----邮件原件-----
> 发件人: Vanessa Ezekowitz [mailto:vanessaezekowitz@gmail.com] 发送时间:
> 2009年4月10日 5:36
> 收件人: support@geniatech.com
> 主题: Technical request regarding the HDTV Thriller X8000A
> 
> THIS IS NOT A USER SUPPORT OR DRIVER REQUEST - WE ALREADY HAVE DRIVERS.
> 
> THIS IS A PROGRAMMER'S REQUEST FOR TECHNICAL INFORMATION.
> 
> To whom it may concern,
> 
> Some time back, I wrote you asking about technical information regarding
> the Thriller X8000A board.  I never received a reply, so I am writing
> again.
> 
> I own a card that is a chip-for-chip, wire-for-wire clone of the
> Thriller X8000A, the Kworld HD PCI 120 (also called the "ATSC 120" for
> short) - it is programmatically indistinguishable from your card.  My
> apologies in advance if I have mistaken which company first made this
> particular card.
> 
> Anyway...  The manufacturer of my card is refusing to answer my
> question, claiming that the data I request has been outright lost and
> can't even be communicated between departments within the company.
> 
> So now, I turn to you, as the maker of a 100% compatible card.
> 
> We of the Linux community have successfully written open-source drivers
> for most of the ATSC120/X8000A's  features, except for one:  we wish to
> add support for this card's remote control unit.
> 
> The Linux Community, whom I am sure you are aware represents a very
> large, rapidly growing market, cannot in good conscience recommend any
> cards, Geniatech or otherwise, which lack complete programming
> information.
> 
> QUESTION:
> 
> On my particular card, this appears to be a 20 pin SMD IC near the IR
> sensor connector.  the manufacturer of my cloned card has deliberately
> removed all the markings from the chip, save for a single green dot of
> paint, and users who own your card have reported similar circumstances.
> 
> Is this mystery chip the remote decoder/receiver chip as I suspect?
> 
> What is the part number of this chip?
> 
> What I2C address does it occupy?
> 
> Where can I acquire a datasheet for it?
> 
> I await your reply.
> 
> --
> "There are some things in life worth obsessing over.  Most things
> aren't, and when you learn that, life improves."
> http://starbase.globalpc.net/~vanessa/ Vanessa Ezekowitz
> <vanessaezekowitz@gmail.com>


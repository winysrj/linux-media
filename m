Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail-ew0-f16.google.com ([209.85.219.16])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <oscarmax3@gmail.com>) id 1LKB3P-0004fr-25
	for linux-dvb@linuxtv.org; Tue, 06 Jan 2009 13:29:05 +0100
Received: by ewy9 with SMTP id 9so7813510ewy.17
	for <linux-dvb@linuxtv.org>; Tue, 06 Jan 2009 04:28:29 -0800 (PST)
Message-ID: <49634E8E.20601@gmail.com>
Date: Tue, 06 Jan 2009 13:29:02 +0100
From: Carl Oscar Ejwertz <oscarmax3@gmail.com>
MIME-Version: 1.0
To: Pauli Borodulin <pauli@borodulin.fi>
References: <49634AFE.2080405@borodulin.fi>
In-Reply-To: <49634AFE.2080405@borodulin.fi>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] The status and future of Mantis driver
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



Den 2009-01-06 13:13, Pauli Borodulin skrev:
> Heya!
>
> I found out that there is some new activity on Manu Abraham's Mantis
> driver, so I thought I could throw in some thoughts about it.
>
> I have been using Manu's Mantis driver (http://www.jusst.de/hg/mantis)
> for over two years now. I have a VP-2033 card (DVB-C) and at least for
> the last year the driver has worked without any hickups in my daily
> (VDR) use. For a long time I have thought that the driver should already
> be merged to the v4l-dvb tree.
>
> Igor M. Liplianin has created a new tree
> (http://mercurial.intuxication.org/hg/s2-liplianin) with the description
> "DVB-S(S2) drivers for Linux". Mantis driver was merged into the tree in
> October and since then some fixes has also been applied to the driver.
> Some of these fixes already exist in Manu's tree, some don't. Both trees
> are missing the remote control support for VP-2033 and VP-2040.
>
> Until merging of the driver into s2-liplianin, there was a single tree
> for the Mantis driver development. Now that there are two trees, I fear
> that the development could scatter if there's no clear idea how the
> driver is going to get into v4l-dvb. Also, the driver is not only
> DVB-S(S2), but it also contains support for VP-2033 (DVB-C), VP-2040
> (DVB-C) and VP-3030 (DVB-T). DVB-S(S2) stuff will probably greatly(?)
> delay getting the support for DVB-C/T Mantis cards into v4l-dvb.
>
> For my personal use I have created a patch against the latest v4l-dvb
> based on Manu's Mantis tree including the remote control support for
> VP-2033 and VP-2040. But what I would really like to see is Mantis
> driver merged into v4l-dvb and later into mainstream.
>
> Igor, what are your thoughts about the Mantis driver? How about the
> other Mantis users, like Marko Ristola, Roland Scheidegger, and Kristian
> Slavov?
>
> Regards,
> Pauli Borodulin
>
> _______________________________________________
> linux-dvb mailing list
> linux-dvb@linuxtv.org
> http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
>
>    

Having a VP-3030 (DVB-T) I can tell you that this card isn't supported 
by the manu tree - but hopefully it will be someday

/Max

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb

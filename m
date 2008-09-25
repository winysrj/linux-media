Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from outbound.icp-qv1-irony-out2.iinet.net.au ([203.59.1.107])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <sonofzev@iinet.net.au>) id 1KisVO-0002S5-Hy
	for linux-dvb@linuxtv.org; Thu, 25 Sep 2008 17:11:47 +0200
From: allan k <sonofzev@iinet.net.au>
To: linux-dvb@linuxtv.org
In-Reply-To: <1222352934.9701.3.camel@media1>
References: <1222352934.9701.3.camel@media1>
Date: Fri, 26 Sep 2008 01:11:38 +1000
Message-Id: <1222355498.17944.1.camel@media1>
Mime-Version: 1.0
Subject: Re: [linux-dvb] how do i get the bt878 driver to show and
	xc-3028	on 2.6.26-gentoo
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

Okay .. 

It seems I had no trouble with the bt-878... but the xc3028 version of
the fusion dual express doesn't seem to be in the kernel (not listed in
the compatible cards)...

I'm going back to mercurial now. 

cheers

Allan

On Fri, 2008-09-26 at 00:28 +1000, allan k wrote:
> Hi all 
> 
> >From what I understand I should now be able to get both my Fusion HDTV
> lite and Fusion Digital Express (cx23885 with xc-3028) to work from
> in-kernel drivers and not use the mercurial tree. 
> 
> Firstly I can't get the bt-878 driver for the lite card to show... I
> know I've done this along time ago, but just can't remember...
> 
> Also I've seen some discussion about the xc3028-dvico-au-01.fw and it's
> compatibility with 2.6.26 but can't see an answer as to whether it works
> or not... any definitive answer or do need to download new firmware from
> somewhere? 
> 
> 
> 
> _______________________________________________
> linux-dvb mailing list
> linux-dvb@linuxtv.org
> http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb

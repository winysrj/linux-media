Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp3-1.goneo.de ([85.220.129.38]:41356 "EHLO smtp3-1.goneo.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750856AbcGTFdf (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 20 Jul 2016 01:33:35 -0400
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Subject: Re: Troubles with kernel-doc and RST files
From: Markus Heiser <markus.heiser@darmarit.de>
In-Reply-To: <20160719165806.2ef581dc@lwn.net>
Date: Wed, 20 Jul 2016 07:32:53 +0200
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	linux-doc@vger.kernel.org, Jani Nikula <jani.nikula@intel.com>
Content-Transfer-Encoding: 7bit
Message-Id: <35894C88-6B22-4F99-BF1C-663DB260B9A1@darmarit.de>
References: <20160717100154.64823d99@recife.lan> <20160717203719.6471fe03@lwn.net> <20160718085420.314119a8@recife.lan> <F6675307-05E6-4101-92E9-69BC0232A939@darmarit.de> <20160719165806.2ef581dc@lwn.net>
To: Jonathan Corbet <corbet@lwn.net>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


Am 20.07.2016 um 00:58 schrieb Jonathan Corbet <corbet@lwn.net>:

> On Tue, 19 Jul 2016 12:00:24 +0200
> Markus Heiser <markus.heiser@darmarit.de> wrote:
> 
>> I recommend to consider to switch to the python version of the parser.
>> I know, that there is a natural shyness about a reimplementation in python
>> and thats why I offer to support it for a long time period .. it would
>> be a joy for me ;-)
>> 
>> If you interested in, I could send a RFC patch for this, if not please
>> give the reasons why not.
> 
> We've had this discussion already...

Hi Jon,

for me -- and may be I'am forgetful -- it was not really clear in 
the past discussion .. anyway I would say; thanks for clarifying  
your POV .. 

>  The problem is not with "python",
> it's with "reimplementation".  We have enough moving parts in this
> transition already; tossing in a wholesale replacement of a tool that,
> for all of its many faults, embodies a couple decades worth of experience
> just doesn't seem like the right thing to do at this time.
> 
> I will be happy to entertain the idea of a new kernel-doc in the future;
> trust me, I have no emotional attachment to the current one.  But please
> let's solidify what we have now first.  There's enough stuff to deal with
> as it is.

OK, now I will accept to stay with the perl one and for this I will send
my next patches ...

Thanks

  -- Markus --



Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp2.goneo.de ([85.220.129.33]:51756 "EHLO smtp2.goneo.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752980AbcJLHFJ (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 12 Oct 2016 03:05:09 -0400
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Subject: Re: [PATCH 0/4] reST-directive kernel-cmd / include contentent from scripts
From: Markus Heiser <markus.heiser@darmarit.de>
In-Reply-To: <20161011134510.0afab942@vento.lan>
Date: Wed, 12 Oct 2016 08:57:02 +0200
Cc: Jani Nikula <jani.nikula@intel.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        "linux-doc@vger.kernel.org Mailing List" <linux-doc@vger.kernel.org>
Content-Transfer-Encoding: 7bit
Message-Id: <A6E1514E-7011-4FB0-BAFB-C81E3CFA45A5@darmarit.de>
References: <1475738420-8747-1-git-send-email-markus.heiser@darmarit.de> <87oa2xrhqx.fsf@intel.com> <20161006103132.3a56802a@vento.lan> <87lgy15zin.fsf@intel.com> <20161006135028.2880f5a5@vento.lan> <8737k8ya6f.fsf@intel.com> <8E74FF11-208D-4C76-8A8C-2B2102E5CB20@darmarit.de> <20161011112853.01e15632@vento.lan> <87vawyyk5v.fsf@intel.com> <E8B76D61-2072-431B-AAB0-E85475D7BFB6@darmarit.de> <20161011134510.0afab942@vento.lan>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


Am 11.10.2016 um 18:45 schrieb Mauro Carvalho Chehab <mchehab@infradead.org>:

> If we allow such scripts (and we do since day zero, due to
> kernel-doc), then there are 3 options:
> 
> 1) use a single python script to run the scripts needed in the
>   build process (e. g. merging kernel-cmd extension upstream);
> 
> 2) use a dedicated python script for every non-phyton script;
> 
> 3) use only python scripts to extend Sphinx functionality.
> 
> The (2) scenario seems to be the worse case, as it will end by
> having a perl(/shell?) script/python script pair for every 
> non-python script we need to run, we're actually making it twice
> worse.
> 
> For (3) to happen, we'll need to convert both kernel-doc and
> parse-headers.pl to Python. This could be a long term goal,
> but I prefer to not rewrite those scripts for a while, as
> it is a lot easier to maintain them in perl, at least to me, and it
> is less disruptive, as rewriting kernel-doc to Python can introduce
> regressions.
> 

Hi Mauro,

its a bit OT in this thread, but in the linuxdoc project,
the kernel-doc is already converted to python.

  https://return42.github.io/linuxdoc/cmd-line.html#kernel-doc

and you have used it already, when you lint with kernel-lint.
Hence I see more progressions than regression ;-)

> So, the way I see, (1) is the best approach.

agree

--Markus--

> 
>> Anyway, these are only my 2cent. I'am interested in what Jon says
>> in general about using (Perl) scripts to generate reST content.
>> 
>> --Markus--
>> 
> 
> Regards,
> Mauro


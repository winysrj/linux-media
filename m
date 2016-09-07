Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp1.goneo.de ([85.220.129.30]:39596 "EHLO smtp1.goneo.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932305AbcIGIBn (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 7 Sep 2016 04:01:43 -0400
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Subject: Re: [PATCH 1/3] doc-rst:c-domain: fix sphinx version incompatibility
From: Markus Heiser <markus.heiser@darmarit.de>
In-Reply-To: <20160906125518.05a9d9fd@vento.lan>
Date: Wed, 7 Sep 2016 10:01:10 +0200
Cc: Jani Nikula <jani.nikula@intel.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        linux-doc@vger.kernel.org
Content-Transfer-Encoding: 8BIT
Message-Id: <597B1314-5C67-4F08-BD67-9F37BC5E264A@darmarit.de>
References: <1472657372-21039-1-git-send-email-markus.heiser@darmarit.de> <1472657372-21039-2-git-send-email-markus.heiser@darmarit.de> <20160906061909.36aa2986@lwn.net> <87k2epxiby.fsf@intel.com> <3F2C3A86-D578-4978-AFFB-8B34DA758BE6@darmarit.de> <20160906125518.05a9d9fd@vento.lan>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


Am 06.09.2016 um 17:55 schrieb Mauro Carvalho Chehab <mchehab@infradead.org>:
...
>> Sphinx has some more of these tuples with fixed length (remember
>> conf.py, the latex_documents settings) where IMHO hash/value pairs
>> (dicts) are more suitable.
> 
> Well, the LaTeX stuff at conf.py seems to have a new field on version
> 1.4.x. At least, our config has:
> 
> # (source start file, name, description, authors, manual section).
> 
> but 1.4.x docs mentions another tuple: toctree_only.

Hmm, as far as I can see, toctree_only is supported since Release 0.3 
(May 6, 2008):

  https://github.com/sphinx-doc/sphinx/blob/master/CHANGES.old#L1025

But is was implemented optional (from the beginning):

 https://github.com/sphinx-doc/sphinx/blame/master/sphinx/builders/latex.py#L104

-- Markus --

> 
> Regards,
> Mauro
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


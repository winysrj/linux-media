Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:6221 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751608AbcJGF4N (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 7 Oct 2016 01:56:13 -0400
From: Jani Nikula <jani.nikula@intel.com>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: Markus Heiser <markus.heiser@darmarit.de>,
        Jonathan Corbet <corbet@lwn.net>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        linux-doc@vger.kernel.org
Subject: Re: [PATCH 0/4] reST-directive kernel-cmd / include contentent from scripts
In-Reply-To: <20161006135028.2880f5a5@vento.lan>
References: <1475738420-8747-1-git-send-email-markus.heiser@darmarit.de> <87oa2xrhqx.fsf@intel.com> <20161006103132.3a56802a@vento.lan> <87lgy15zin.fsf@intel.com> <20161006135028.2880f5a5@vento.lan>
Date: Fri, 07 Oct 2016 08:56:08 +0300
Message-ID: <8737k8ya6f.fsf@intel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, 06 Oct 2016, Mauro Carvalho Chehab <mchehab@infradead.org> wrote:
> Em Thu, 06 Oct 2016 17:21:36 +0300
> Jani Nikula <jani.nikula@intel.com> escreveu:
>> We've seen what happens when we make it easy to add random scripts to
>> build documentation. We've worked hard to get rid of that. In my books,
>> one of the bigger points in favor of Sphinx over AsciiDoc(tor) was
>> getting rid of all the hacks required in the build. Things that broke in
>> subtle ways.
>
> I really can't see what scripts it get rids.

Really? You don't see why the DocBook build was so fragile and difficult
to maintain? That scares me a bit, because then you will not have
learned why we should at all costs avoid adding random scripts to
produce documentation.

The DocBook build was designed by Rube Goldberg, and this video
accurately illustrates how it works:
https://www.youtube.com/watch?v=qybUFnY7Y8w

I don't want the Sphinx build to end up like that.


BR,
Jani.


-- 
Jani Nikula, Intel Open Source Technology Center

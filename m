Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp2-2.goneo.de ([85.220.129.34]:39792 "EHLO smtp2-2.goneo.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752791AbcKIL2C (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 9 Nov 2016 06:28:02 -0500
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Subject: Re: [Ksummit-discuss] Including images on Sphinx documents
From: Markus Heiser <markus.heiser@darmarit.de>
In-Reply-To: <8737j0hpi0.fsf@intel.com>
Date: Wed, 9 Nov 2016 12:27:48 +0100
Cc: Josh Triplett <josh@joshtriplett.org>,
        Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Jonathan Corbet <corbet@lwn.net>, linux-kernel@vger.kernel.org,
        linux-media@vger.kernel.org,
        ksummit-discuss@lists.linuxfoundation.org,
        linux-doc@vger.kernel.org
Content-Transfer-Encoding: 7bit
Message-Id: <DC27B5F7-D69E-4F22-B184-B7B029392959@darmarit.de>
References: <20161107075524.49d83697@vento.lan> <20161107170133.4jdeuqydthbbchaq@x> <A4091944-D727-45B5-AC24-FE3B2700298E@darmarit.de> <8737j0hpi0.fsf@intel.com>
To: Jani Nikula <jani.nikula@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


Am 09.11.2016 um 12:16 schrieb Jani Nikula <jani.nikula@linux.intel.com>:
>> So I vote for :
>> 
>>> 1) copy (or symlink) all rst files to Documentation/output (or to the
>>> build dir specified via O= directive) and generate the *.pdf there,
>>> and produce those converted images via Makefile.;
> 
> We're supposed to solve problems, not create new ones.

... new ones? ...

>> IMO placing 'sourcedir' to O= is more sane since this marries the
>> Linux Makefile concept (relative to $PWD) with the sphinx concept
>> (in or below 'sourcedir').

-- Markus --

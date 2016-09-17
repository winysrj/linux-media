Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp2.goneo.de ([85.220.129.33]:52588 "EHLO smtp2.goneo.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751320AbcIQJpw (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sat, 17 Sep 2016 05:45:52 -0400
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Subject: Re: [PATCH v2 0/3] doc-rst:c-domain: fix some issues in the c-domain
From: Markus Heiser <markus.heiser@darmarit.de>
In-Reply-To: <20160916100226.055683ed@lwn.net>
Date: Sat, 17 Sep 2016 11:45:09 +0200
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
        Jani Nikula <jani.nikula@intel.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        linux-doc@vger.kernel.org
Content-Transfer-Encoding: 8BIT
Message-Id: <17330187-A107-472D-98F0-044C768A7E7C@darmarit.de>
References: <1473232378-11869-1-git-send-email-markus.heiser@darmarit.de> <20160916100226.055683ed@lwn.net>
To: Jonathan Corbet <corbet@lwn.net>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


Am 16.09.2016 um 18:02 schrieb Jonathan Corbet <corbet@lwn.net>:

> On Wed,  7 Sep 2016 09:12:55 +0200
> Markus Heiser <markus.heiser@darmarit.de> wrote:
> 
>> according to your remarks I fixed the first and second patch. The third patch is
>> resend unchanged;
> 
> OK, I've applied the first two, finally.
...

> Information hiding is the only way we can maintain the kernel and stay
> sane.  I have a hard time imagining why somebody would be looking for a
> macro in particular; the whole idea is that they really shouldn't have to
> care.  So my inclination is to leave this one out, sorry.

OK, thanks.
 
-- Markus --

> 
> Thanks,
> 
> jon


Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtprelay0169.hostedemail.com ([216.40.44.169]:53884 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1750974AbdEaCQf (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 30 May 2017 22:16:35 -0400
Message-ID: <1496196991.2618.47.camel@perches.com>
Subject: Re: [PATCH v2] [media] vb2: core: Lower the log level of debug
 outputs
From: Joe Perches <joe@perches.com>
To: Hirokazu Honda <hiroh@chromium.org>,
        Pawel Osciak <pawel@osciak.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Tue, 30 May 2017 19:16:31 -0700
In-Reply-To: <CAO5uPHO7GwxCTk2OqQA5NfrL0-Jyt5SB-jVpeUA_eCrqR7u5xA@mail.gmail.com>
References: <20170530094901.1807-1-hiroh@chromium.org>
         <1496139572.2618.19.camel@perches.com>
         <CAO5uPHO7GwxCTk2OqQA5NfrL0-Jyt5SB-jVpeUA_eCrqR7u5xA@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, 2017-05-31 at 11:05 +0900, Hirokazu Honda wrote:
> Although bitmap is useful, there is need to change the log level for each
> log.
> Because it will take a longer time, it should be done in another patch.

I have no idea what you mean.

A bit & comparison is typically an identical instruction
cycle count to a >= comparison.

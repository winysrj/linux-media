Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtprelay0136.hostedemail.com ([216.40.44.136]:56006 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1750862AbdEaEGq (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 31 May 2017 00:06:46 -0400
Message-ID: <1496203602.2618.54.camel@perches.com>
Subject: Re: [PATCH v2] [media] vb2: core: Lower the log level of debug
 outputs
From: Joe Perches <joe@perches.com>
To: Hirokazu Honda <hiroh@chromium.org>
Cc: Pawel Osciak <pawel@osciak.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Tue, 30 May 2017 21:06:42 -0700
In-Reply-To: <CAO5uPHPWGABuKf3FuAky2BRx+9E=n-QhZ94RPQ7wEuHAwC1qGg@mail.gmail.com>
References: <20170530094901.1807-1-hiroh@chromium.org>
         <1496139572.2618.19.camel@perches.com>
         <CAO5uPHO7GwxCTk2OqQA5NfrL0-Jyt5SB-jVpeUA_eCrqR7u5xA@mail.gmail.com>
         <1496196991.2618.47.camel@perches.com>
         <CAO5uPHPWGABuKf3FuAky2BRx+9E=n-QhZ94RPQ7wEuHAwC1qGg@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, 2017-05-31 at 12:28 +0900, Hirokazu Honda wrote:
> If I understand a bitmap correctly, it is necessary to change the log level
> for each message.
> I didn't mean a bitmap will take a long CPU time.
> I mean the work to change so takes a long time.

No, none of the messages or levels need change,
only the >= test changes to & so that for instance,
level 1 and level 3 messages could be emitted
without also emitting level 2 messages.

The patch suggested is all that would be required.

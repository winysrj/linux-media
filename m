Return-path: <linux-media-owner@vger.kernel.org>
Received: from quechua.inka.de ([193.197.184.2]:46311 "EHLO mail.inka.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751711AbeDLNAK (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 12 Apr 2018 09:00:10 -0400
Date: Thu, 12 Apr 2018 14:52:03 +0200
From: Josef Wolf <jw@raven.inka.de>
To: linux-media@vger.kernel.org
Subject: Re: Confusion about API: please clarify
Message-ID: <20180412125203.GC28895@raven.inka.de>
References: <20180410104327.GA28895@raven.inka.de>
 <20180410115815.51ac801b@vento.lan>
 <20180410191423.GB28895@raven.inka.de>
 <20180410172239.647957ba@vento.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180410172239.647957ba@vento.lan>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Di, Apr 10, 2018 at 05:22:39 -0300, Mauro Carvalho Chehab wrote:
> That's said, adding suport for DiSEqC with more than 6 bytes should
> likely be enabled driver per driver, after checking that the device
> supports it.

Do you know which length saa7146/stv0299 could do?

-- 
Josef Wolf
jw@raven.inka.de

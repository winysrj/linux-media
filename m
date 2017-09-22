Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtprelay0100.hostedemail.com ([216.40.44.100]:43289 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751845AbdIVShL (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 22 Sep 2017 14:37:11 -0400
Message-ID: <1506105423.12311.44.camel@perches.com>
Subject: Re: [media] spca500: Use common error handling code in
 spca500_synch310()
From: Joe Perches <joe@perches.com>
To: SF Markus Elfring <elfring@users.sourceforge.net>,
        Julia Lawall <julia.lawall@lip6.fr>,
        linux-media@vger.kernel.org
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        LKML <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org
Date: Fri, 22 Sep 2017 11:37:03 -0700
In-Reply-To: <0baa322a-6019-70dc-0245-caae824ccb49@users.sourceforge.net>
References: <d496ca24-1725-768b-5e55-4e45097cb77d@users.sourceforge.net>
         <alpine.DEB.2.20.1709221908230.3170@hadrien>
         <4921ea61-49cd-4071-e636-c199daddec8e@users.sourceforge.net>
         <alpine.DEB.2.20.1709221941020.3170@hadrien>
         <0baa322a-6019-70dc-0245-caae824ccb49@users.sourceforge.net>
Content-Type: text/plain; charset="ISO-8859-1"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, 2017-09-22 at 19:46 +0200, SF Markus Elfring wrote:
> > > > They are both equally uninformative.
> > > 
> > > Which identifier would you find appropriate there?
> > 
> > error was fine.
> 
> How do the different views fit together?

Markus, please respect what others tell you because
your coding style "taste" could be improved.

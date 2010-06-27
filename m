Return-path: <linux-media-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.157]:1339 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754701Ab0F0PUq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 27 Jun 2010 11:20:46 -0400
Received: by fg-out-1718.google.com with SMTP id e21so232041fga.1
        for <linux-media@vger.kernel.org>; Sun, 27 Jun 2010 08:20:45 -0700 (PDT)
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Apple Message framework v1081)
Subject: Re: TS discontinuity with TT S-2300
From: Jaroslav Klaus <jaroslav.klaus@gmail.com>
In-Reply-To: <201006271437.01502@orion.escape-edv.de>
Date: Sun, 27 Jun 2010 17:23:31 +0200
Content-Transfer-Encoding: 8BIT
Message-Id: <3CBBD92C-CC3B-42A1-8E74-C27508B26CB0@gmail.com>
References: <1CF58597-201D-4448-A80C-55815811753E@gmail.com> <201006271437.01502@orion.escape-edv.de>
To: linux-media@vger.kernel.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


On 27.6.2010, at 14:37, Oliver Endriss wrote:

> Hi,
> 
> On Sunday 27 June 2010 01:05:57 Jaroslav Klaus wrote:
>> Hi,
>> 
>> I'm loosing TS packets in my dual CAM premium TT S-2300 card (av7110+saa7146).
>> Do you thing it is av7110 issue? Do you know any relevant limits of
>> av7110? What should I test/try more? Thanks 
> 
> The full-featured cards are not able to deliver the full bandwidth of a
> transponder. It is a limitaion of the board design, not a firmware or
> driver issue.

I thought full bandwidth is impossible to process but I thought 4 TV channel should be ok. It's too much obviously. Especially when peaks of all TV channels meet in the same time.

> You can fix this by applying the 'full-ts' hardware modification.
> For more information follow the link in my signature.

Great link. This really make sense. Thanks

Jaroslav


Return-path: <linux-media-owner@vger.kernel.org>
Received: from butterbrot.org ([176.9.106.16]:52886 "EHLO butterbrot.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752349AbdJDPTk (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 4 Oct 2017 11:19:40 -0400
Received: from localhost (localhost [127.0.0.1])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by butterbrot.org (Postfix) with ESMTPS id 47DEF4AE0598
        for <linux-media@vger.kernel.org>; Wed,  4 Oct 2017 17:19:39 +0200 (CEST)
Date: Wed, 4 Oct 2017 17:19:39 +0200 (CEST)
From: Florian Echtler <floe@butterbrot.org>
To: linux-media@vger.kernel.org
Subject: Re: Regression on 4.10 with Logitech Quickcam Sphere
In-Reply-To: <alpine.DEB.2.10.1710012003100.18874@butterbrot>
Message-ID: <alpine.DEB.2.10.1710041716470.18874@butterbrot>
References: <alpine.DEB.2.10.1710012003100.18874@butterbrot>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello again,

solved it myself, posting here for the record.

Solution is to install uvcdynctrl and running

uvcdynctrl -i /usr/share/uvcdynctrl/data/046d/logitech.xml

And voila, custom controls back again. Not well documented, but hey.

Best regards, Florian

On Sun, 1 Oct 2017, Florian Echtler wrote:

> Hello everyone,
>
> I recently upgraded from a 4.4 kernel to 4.10, and found that my Logitech 
> Quickcam Sphere now behaves differently.
>
> More specifically, the pan/tilt controls do not work anymore - in fact, they 
> are completely gone from "v4l2-ctl -L".
>
> I suspect that https://bugzilla.kernel.org/show_bug.cgi?id=111291#c10 may be 
> related, and the new extension handling causes the pan/tilt controls to 
> disappear.
>
> Question now is, how to get them back?
>
> Best, Florian

-- 
"_Nothing_ brightens up my morning. Coffee simply provides a shade of
grey just above the pitch-black of the infinite depths of the _abyss_."

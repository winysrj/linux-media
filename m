Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bw0-f210.google.com ([209.85.218.210]:41745 "EHLO
	mail-bw0-f210.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754018AbZIUDk5 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 20 Sep 2009 23:40:57 -0400
Received: by bwz6 with SMTP id 6so1698005bwz.37
        for <linux-media@vger.kernel.org>; Sun, 20 Sep 2009 20:40:59 -0700 (PDT)
MIME-Version: 1.0
Date: Mon, 21 Sep 2009 05:40:59 +0200
Message-ID: <d9def9db0909202040u3138670ahede6078ef1a177c@mail.gmail.com>
Subject: Bug in S2 API...
From: Markus Rechberger <mrechberger@gmail.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

while porting the S2api to userspace I came accross the S2-API definition itself

#define FE_SET_PROPERTY            _IOW('o', 82, struct dtv_properties)
#define FE_GET_PROPERTY            _IOR('o', 83, struct dtv_properties)

while looking at this, FE_GET_PROPERTY should very likely be _IOWR

in dvb-frontend.c:
----
        if(cmd == FE_GET_PROPERTY) {

                tvps = (struct dtv_properties __user *)parg;

                dprintk("%s() properties.num = %d\n", __func__, tvps->num);
                dprintk("%s() properties.props = %p\n", __func__, tvps->props);
                ...
                if (copy_from_user(tvp, tvps->props, tvps->num *
sizeof(struct dtv_property)))
----

Regards,
Markus

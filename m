Return-path: <linux-media-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.152]:37037 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751795Ab0AUMH6 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 21 Jan 2010 07:07:58 -0500
Received: by fg-out-1718.google.com with SMTP id 16so1350991fgg.1
        for <linux-media@vger.kernel.org>; Thu, 21 Jan 2010 04:07:56 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <135ab3ff1001210155qad2c794rf6781c4ac28159c7@mail.gmail.com>
References: <135ab3ff1001200926j9917d69x51eede94512fa664@mail.gmail.com>
	 <829197381001201000x58aadea5wab0948691d9a4c4f@mail.gmail.com>
	 <135ab3ff1001210155qad2c794rf6781c4ac28159c7@mail.gmail.com>
Date: Thu, 21 Jan 2010 13:07:56 +0100
Message-ID: <d9def9db1001210407s6f14d637x1e32d34f7193a188@mail.gmail.com>
Subject: Re: Drivers for Eyetv hybrid
From: Markus Rechberger <mrechberger@gmail.com>
To: Morten Friesgaard <friesgaard@gmail.com>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Jan 21, 2010 at 10:55 AM, Morten Friesgaard
<friesgaard@gmail.com> wrote:
> To bad. I bought this tuner because of the cross platform compability :-/
>
> Well, it looks awfully alot like the TerraTec H5, would there be a
> driver this one?
> http://www.terratec.net/en/products/TerraTec_H5_83188.html
>

just fyi. this Terratec device is not supported. We've been working on
a device with equivalent features
(DVB-T/C/AnalogTV/VBI/Composite/S-Video/FM-Radio/RDS/Remote Control)
http://support.sundtek.com/index.php/topic,4.0.html
We are also integrating additional flexible USB CI support for it.

Best Regards,
Markus Rechberger

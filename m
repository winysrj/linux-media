Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:61168 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753335Ab1JMQPo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 13 Oct 2011 12:15:44 -0400
Received: by bkbzt4 with SMTP id zt4so1653965bkb.19
        for <linux-media@vger.kernel.org>; Thu, 13 Oct 2011 09:15:43 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4E970CA7.8020807@iki.fi>
References: <CAGa-wNOL_1ua0DQFRPFuLtHO0zTFhE0DaM+b6kujMEEL4dQbKg@mail.gmail.com>
	<CAGoCfizwYRpSsqobaHWJd5d0wq1N0KSXEQ1Un_ue01KuYGHaWA@mail.gmail.com>
	<4E970CA7.8020807@iki.fi>
Date: Thu, 13 Oct 2011 12:15:42 -0400
Message-ID: <CAGoCfiwSJ7EGXxAw7UgbFeECh+dg1EueXEC9iCHu7TaXia=-mQ@mail.gmail.com>
Subject: Re: PCTV 520e on Linux
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Antti Palosaari <crope@iki.fi>
Cc: Claus Olesen <ceolesen@gmail.com>, linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Oct 13, 2011 at 12:07 PM, Antti Palosaari <crope@iki.fi> wrote:
>> No support currently.  I have the stick, but haven't had any time to work
>> on it.
>
> Is that EM28xx + DRX-K + TDA18217 ? And analog parts...

You were close:  em2884, drx-k, xc5000, and for analog it uses the afv4910b.

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com

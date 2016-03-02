Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud2.xs4all.net ([194.109.24.25]:60886 "EHLO
	lb2-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751240AbcCBIcV (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 2 Mar 2016 03:32:21 -0500
To: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Ezequiel Garcia <ezequiel@vanguardiasur.com.ar>,
	=?UTF-8?Q?Krzysztof_Ha=c5=82asa?= <khalasa@piap.pl>
From: Hans Verkuil <hverkuil@xs4all.nl>
Subject: tw686x driver
Message-ID: <56D6A50F.4060404@xs4all.nl>
Date: Wed, 2 Mar 2016 09:32:15 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Krzysztof, Ezequiel,

Last Monday I compared the two proposed drivers and I decided to go with Ezequiel's
code. The reasons are that his code has audio support and FIELD_INTERLACED support,
and the reality is that most users (read applications) want full frames instead of
fields. In addition his code was a bit more mature since it had gone through a careful
code review already.

I am obviously unhappy having to choose between two drivers. But the alternative
would be to not have anything merged, and then *everyone* would be unhappy.

Ezequiel, I've asked for two small changes to your v2. Once I have v3 I will make
a pull request.

So lessons learned:

Krzysztof, next time don't wait many months before posting a new version fixing
requested changes.

Ezequiel, next time don't throw away functionality of the original code, instead
just add your own functionality to it.

Regards,

	Hans

Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud9.xs4all.net ([194.109.24.30]:38496 "EHLO
        lb3-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726656AbeJHTE4 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 8 Oct 2018 15:04:56 -0400
To: Nicolas Dufresne <nicolas@ndufresne.ca>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Ezequiel Garcia <ezequiel@collabora.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
From: Hans Verkuil <hverkuil@xs4all.nl>
Subject: [RFC] Informal meeting during ELCE to discuss userspace support for
 stateless codecs
Message-ID: <b9b2f5ea-8593-d1bf-6d4f-c2efddaa7002@xs4all.nl>
Date: Mon, 8 Oct 2018 13:53:29 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi all,

I would like to meet up somewhere during the ELCE to discuss userspace support
for stateless (and perhaps stateful as well?) codecs.

It is also planned as a topic during the summit, but I would prefer to prepare
for that in advance, esp. since I myself do not have any experience writing
userspace SW for such devices.

Nicolas, it would be really great if you can participate in this meeting
since you probably have the most experience with this by far.

Looking through the ELCE program I found two timeslots that are likely to work
for most of us (because the topics in the program appear to be boring for us
media types!):

Tuesday from 10:50-15:50

or:

Monday from 15:45 onward

My guess is that we need 2-3 hours or so. Hard to predict.

The basic question that I would like to have answered is what the userspace
component should look like? libv4l-like plugin or a library that userspace can
link with? Do we want more general support for stateful codecs as well that deals
with resolution changes and the more complex parts of the codec API?

I've mailed this directly to those that I expect are most interested in this,
but if someone want to join in let me know.

I want to keep the group small though, so you need to bring relevant experience
to the table.

Regards,

	Hans

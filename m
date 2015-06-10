Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pd0-f177.google.com ([209.85.192.177]:35669 "EHLO
	mail-pd0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751456AbbFJIkI (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 10 Jun 2015 04:40:08 -0400
Received: by pdbnf5 with SMTP id nf5so33219577pdb.2
        for <linux-media@vger.kernel.org>; Wed, 10 Jun 2015 01:40:08 -0700 (PDT)
Message-ID: <5577F7E9.9080609@igel.co.jp>
Date: Wed, 10 Jun 2015 17:40:09 +0900
From: Damian Hobson-Garcia <dhobsong@igel.co.jp>
MIME-Version: 1.0
To: "Enrico Weigelt, metux IT consult" <weigelt@melag.de>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: Re: [RFC] V4L2 codecs in user space
References: <em1e648821-484a-48b8-afe4-beed2241343a@damian-pc> <55751D44.6010102@igel.co.jp> <55755168.40108@xs4all.nl> <5575666E.90508@igel.co.jp> <557568A8.1080409@xs4all.nl> <5577F2A7.6090306@melag.de>
In-Reply-To: <5577F2A7.6090306@melag.de>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Enrico,

On 2015-06-10 5:17 PM, Enrico Weigelt, metux IT consult wrote:
> Am 08.06.2015 um 12:04 schrieb Hans Verkuil:
> 
> <big_snip />
> 
> Just curious: as we're talking about userland libraries,
> why not just using gstreamer ?
> 

I would prefer to use gstreamer if I could, but the application
(Chromium) doesn't support it, so maybe my best option (for now) is to
create a libv4l to gstreamer bridge using the plugin API.

Damian


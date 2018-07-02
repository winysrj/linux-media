Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yw0-f178.google.com ([209.85.161.178]:41156 "EHLO
        mail-yw0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751872AbeGBMeH (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 2 Jul 2018 08:34:07 -0400
Received: by mail-yw0-f178.google.com with SMTP id j5-v6so6597765ywe.8
        for <linux-media@vger.kernel.org>; Mon, 02 Jul 2018 05:34:07 -0700 (PDT)
MIME-Version: 1.0
References: <20180604114648.26159-1-hverkuil@xs4all.nl> <20180604114648.26159-6-hverkuil@xs4all.nl>
In-Reply-To: <20180604114648.26159-6-hverkuil@xs4all.nl>
From: Tomasz Figa <tfiga@google.com>
Date: Mon, 2 Jul 2018 21:33:55 +0900
Message-ID: <CAAFQd5AANgMh8LKT37oNpajyV=LrEkjGsao0Tm9MSe9WXYRabQ@mail.gmail.com>
Subject: Re: [PATCHv15 05/35] media-request: add media_request_object_find
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Hans Verkuil <hans.verkuil@cisco.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,
On Mon, Jun 4, 2018 at 8:48 PM Hans Verkuil <hverkuil@xs4all.nl> wrote:
>
> From: Hans Verkuil <hans.verkuil@cisco.com>
>
> Add media_request_object_find to find a request object inside a
> request based on ops and/or priv values.

Current code seems to always find based on both ops and priv values.

Best regards,
Tomasz

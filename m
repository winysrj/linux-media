Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qt0-f193.google.com ([209.85.216.193]:33227 "EHLO
        mail-qt0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756217AbdGLFof (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 12 Jul 2017 01:44:35 -0400
MIME-Version: 1.0
In-Reply-To: <20170711175704.p2ssblkm7lkincfx@yves>
References: <20170711175704.p2ssblkm7lkincfx@yves>
From: Frans Klaver <fransklaver@gmail.com>
Date: Wed, 12 Jul 2017 07:44:33 +0200
Message-ID: <CAH6sp9PvH5OTsymAnn-8yeT7kEhh-72voZadx4DG28aCKaVmgA@mail.gmail.com>
Subject: Re: [PATCH] Clean up lirc zilog error codes
To: =?UTF-8?Q?Yves_Lem=C3=A9e?= <yves.lemee.kernel@gmail.com>
Cc: mchehab@kernel.org, driverdevel <devel@driverdev.osuosl.org>,
        Greg KH <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-media@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Jul 11, 2017 at 7:57 PM, Yves Lem=C3=A9e <yves.lemee.kernel@gmail.c=
om> wrote:
> According the coding style guidelines, the ENOSYS error code must be retu=
rned
> in case of a non existent system call. This code has been replaced with
> the ENOTTY error code indicating, a missing functionality.
>
> Signed-off-by: Yves Lem=C3=A9e <yves.lemee.kernel@gmail.com>

Your subject line is not according to the patch submission guidelines.

Also, on a nit-picking note, that comma after 'indicating' is rather
oddly placed. Please move or remove it.

Frans

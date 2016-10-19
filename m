Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lf0-f66.google.com ([209.85.215.66]:33268 "EHLO
        mail-lf0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S944339AbcJSSRE (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 19 Oct 2016 14:17:04 -0400
Received: by mail-lf0-f66.google.com with SMTP id l131so3328245lfl.0
        for <linux-media@vger.kernel.org>; Wed, 19 Oct 2016 11:17:03 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <33d775f4e173dd72f82c190bfd2e542749a5481c.1476822925.git.mchehab@s-opensource.com>
References: <cover.1476822924.git.mchehab@s-opensource.com> <33d775f4e173dd72f82c190bfd2e542749a5481c.1476822925.git.mchehab@s-opensource.com>
From: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
Date: Wed, 19 Oct 2016 19:16:32 +0100
Message-ID: <CA+V-a8vb4PgOMbXdTDi2MaEx0fc5ySuNYWjDSHR0yMFu2MU__g@mail.gmail.com>
Subject: Re: [PATCH v2 54/58] i2c: don't break long lines
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Kevin Fitch <kfitch42@gmail.com>,
        Ezequiel Garcia <ezequiel@vanguardiasur.com.ar>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Javier Martinez Canillas <javier@osg.samsung.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Markus Elfring <elfring@users.sourceforge.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

Thanks for the patch.


On Tue, Oct 18, 2016 at 9:46 PM, Mauro Carvalho Chehab
<mchehab@s-opensource.com> wrote:
> Due to the 80-cols restrictions, and latter due to checkpatch
> warnings, several strings were broken into multiple lines. This
> is not considered a good practice anymore, as it makes harder
> to grep for strings at the source code.
>
> As we're right now fixing other drivers due to KERN_CONT, we need
> to be able to identify what printk strings don't end with a "\n".
> It is a way easier to detect those if we don't break long lines.
>
> So, join those continuation lines.
>
> The patch was generated via the script below, and manually
> adjusted if needed.
>
> </script>
> use Text::Tabs;
> while (<>) {
>         if ($next ne "") {
>                 $c=$_;
>                 if ($c =~ /^\s+\"(.*)/) {
>                         $c2=$1;
>                         $next =~ s/\"\n$//;
>                         $n = expand($next);
>                         $funpos = index($n, '(');
>                         $pos = index($c2, '",');
>                         if ($funpos && $pos > 0) {
>                                 $s1 = substr $c2, 0, $pos + 2;
>                                 $s2 = ' ' x ($funpos + 1) . substr $c2, $pos + 2;
>                                 $s2 =~ s/^\s+//;
>
>                                 $s2 = ' ' x ($funpos + 1) . $s2 if ($s2 ne "");
>
>                                 print unexpand("$next$s1\n");
>                                 print unexpand("$s2\n") if ($s2 ne "");
>                         } else {
>                                 print "$next$c2\n";
>                         }
>                         $next="";
>                         next;
>                 } else {
>                         print $next;
>                 }
>                 $next="";
>         } else {
>                 if (m/\"$/) {
>                         if (!m/\\n\"$/) {
>                                 $next=$_;
>                                 next;
>                         }
>                 }
>         }
>         print $_;
> }
> </script>
>
> Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>

Acked-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>

Cheers,
--Prabhakar Lad

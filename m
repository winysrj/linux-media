Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-gg0-f174.google.com ([209.85.161.174]:34162 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752479Ab2GZTqM (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 26 Jul 2012 15:46:12 -0400
Received: by gglu4 with SMTP id u4so2386498ggl.19
        for <linux-media@vger.kernel.org>; Thu, 26 Jul 2012 12:46:12 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <501196C4.1020909@googlemail.com>
References: <1343238241-26772-1-git-send-email-kradlow@cisco.com>
	<89e7f656fc45f12f2cb5369738b3afd1f712674f.1343237398.git.kradlow@cisco.com>
	<501196C4.1020909@googlemail.com>
Date: Thu, 26 Jul 2012 21:46:08 +0200
Message-ID: <CAFomkUCeCK8AAh85ch=Yn_rX0pNaXAuzuFKsGeHj-2A3GQgGrg@mail.gmail.com>
Subject: Re: [RFC PATCH 2/2] Initial version of RDS Control utility
 Signed-off-by: Konke Radlow <kradlow@cisco.com>
From: Konke Radlow <koradlow@googlemail.com>
To: Gregor Jasny <gjasny@googlemail.com>
Cc: Konke Radlow <kradlow@cisco.com>, linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

1.
> +#ifdef HAVE_SYS_KLOG_H
> +#include <sys/klog.h>
> +#endif

I'll drop those lines

2.
> +             case OptSetDevice:
> +                     strncpy(params.fd_name, optarg, 80);
> +                     if (optarg[0] >= '0' && optarg[0] <= '9' && optarg[1] == 0) {

I didn't know about the isalpha function, thanks for the hint

3.
> +     if (params.options[OptPrintBlock])
> +             updated_fields = 0xFFFFFFFF;

will use that handy definition (UINT32_MAX )

4.
> +     int opt = 0;
> +     char short_options[26 * 2 * 2 + 1];

the number 26 was taken over from the code of the v4l2-ctl tool. I don't know
where that "magic" number is coming from. I just checked the v4l2-ctl code again
and there seem to be 26 short options defined in the "enum Option" type.


Thank you for your comments so far. I'll incorporate them tomorrow
morning when I'm
back on my working machine,

regards,
Konke



On Thu, Jul 26, 2012 at 9:13 PM, Gregor Jasny <gjasny@googlemail.com> wrote:
>
> On 7/25/12 7:44 PM, Konke Radlow wrote:
>
> > +static void print_rds_af(struct v4l2_rds_af_set *af_set)
> > +{
> > +     int counter = 0;
> > +
> > +     printf("\nAnnounced AFs: %u", af_set->announced_af);
> > +     for (int i = 0; i < af_set->size && i < af_set->announced_af; i++, counter++) {
> > +             if (af_set->af[i] >= 87500000 ) {
> > +                     printf("\nAF%02d: %.1fMHz", counter, af_set->af[i] / 1000000.0);
> > +                     continue;
> > +             }
> > +             printf("\nAF%02d: %.1fkHz", counter, af_set->af[i] / 1000.0);
> > +     }
> > +}
> > +
> > +static void print_rds_pi(const struct v4l2_rds *handle)
> > +{
> > +     printf("\nArea Coverage: %s", v4l2_rds_get_coverage_str(handle));
> > +}
> > +
> > +static void print_rds_data(struct v4l2_rds *handle, uint32_t updated_fields)
> > +{
> > +     if (params.options[OptPrintBlock])
> > +             updated_fields = 0xFFFFFFFF;
>
> You could use UINT32_MAX here
>
> > +
> > +     if (updated_fields & V4L2_RDS_PI &&
> > +                     handle->valid_fields & V4L2_RDS_PI) {
> > +             printf("\nPI: %04x", handle->pi);
> > +             print_rds_pi(handle);
> > +     }
>
> > +static int parse_cl(int argc, char **argv)
> > +{
> > +     int i = 0;
> > +     int idx = 0;
> > +     int opt = 0;
> > +     char short_options[26 * 2 * 2 + 1];
>
> Where comes the 26 and 2 from?
> Could this be (ARRAY_SIZE(long_options) + 1 ) * 2?
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

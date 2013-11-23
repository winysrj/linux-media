Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-la0-f53.google.com ([209.85.215.53]:35832 "EHLO
	mail-la0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750945Ab3KWLPL (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 23 Nov 2013 06:15:11 -0500
Received: by mail-la0-f53.google.com with SMTP id ea20so1677765lab.12
        for <linux-media@vger.kernel.org>; Sat, 23 Nov 2013 03:15:10 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <5290899A.8070707@xs4all.nl>
References: <5290899A.8070707@xs4all.nl>
Date: Sat, 23 Nov 2013 16:45:09 +0530
Message-ID: <CAHFNz9J==ebJN-um61-UeeWce81usYpn-QWD8PB2FsGqZwLupg@mail.gmail.com>
Subject: Re: [PATCHv2 dvb-apps] Silence last warnings in dvbscan.c
From: Manu Abraham <abraham.manu@gmail.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Michael Krufky <mkrufky@linuxtv.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, Nov 23, 2013 at 4:25 PM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
> Hi Mike,
>
> This is the revised version of the patch I mailed earlier. As you requested
> I now use #if 0 instead of commenting out line to silence the warnings.
>
> Regards,
>
>         Hans
>
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
>
> diff -r 7161fa4a3e33 util/dvbscan/dvbscan.c
> --- a/util/dvbscan/dvbscan.c    Thu Nov 14 16:45:24 2013 -0500
> +++ b/util/dvbscan/dvbscan.c    Sat Nov 23 11:54:53 2013 +0100
> @@ -74,8 +74,8 @@
>                 "                                               Dual LO, H:5150MHz, V:5750MHz.\n"
>                 "                        * One of the sec definitions from the secfile if supplied\n"
>                 " -satpos <position>    Specify DISEQC switch position for DVB-S.\n"
> -               " -inversion <on|off|auto> Specify inversion (default: auto).\n"
> -               " -uk-ordering          Use UK DVB-T channel ordering if present.\n"
> +               " -inversion <on|off|auto> Specify inversion (default: auto) (note: this option is ignored).\n"
> +               " -uk-ordering          Use UK DVB-T channel ordering if present (note: this option is ignored).\n"
>                 " -timeout <secs>       Specify filter timeout to use (standard specced values will be used by default)\n"
>                 " -filter <filter>      Specify service filter, a comma seperated list of the following tokens:\n"
>                 "                        (If no filter is supplied, all services will be output)\n"
> @@ -83,10 +83,11 @@
>                 "                        * radio - Output radio channels\n"
>                 "                        * other - Output other channels\n"
>                 "                        * encrypted - Output encrypted channels\n"
> -               " -out raw <filename>|-  Output in raw format to <filename> or stdout\n"
> +               " -out raw <filename>|- Output in raw format to <filename> or stdout\n"
>                 "      channels <filename>|-  Output in channels.conf format to <filename> or stdout.\n"
>                 "      vdr12 <filename>|- Output in vdr 1.2.x format to <filename> or stdout.\n"
>                 "      vdr13 <filename>|- Output in vdr 1.3.x format to <filename> or stdout.\n"
> +               "                       Note: this option is ignored.\n"
>                 " <initial scan file>\n";
>         fprintf(stderr, "%s\n", _usage);
>
> @@ -121,15 +122,17 @@
>         char *secfile = NULL;
>         char *secid = NULL;
>         int satpos = 0;
> -       enum dvbfe_spectral_inversion inversion = DVBFE_INVERSION_AUTO;
>         int service_filter = -1;
> -       int uk_ordering = 0;
>         int timeout = 5;
> -       int output_type = OUTPUT_TYPE_RAW;
> -       char *output_filename = NULL;
>         char *scan_filename = NULL;
>         struct dvbsec_config sec;
>         int valid_sec = 0;
> +#if 0
> +       char *output_filename = NULL;
> +       enum dvbfe_spectral_inversion inversion = DVBFE_INVERSION_AUTO;
> +       int output_type = OUTPUT_TYPE_RAW;
> +       int uk_ordering = 0;
> +#endif
>
>         while(argpos != argc) {
>                 if (!strcmp(argv[argpos], "-h")) {
> @@ -171,6 +174,7 @@
>                 } else if (!strcmp(argv[argpos], "-inversion")) {
>                         if ((argc - argpos) < 2)
>                                 usage();
> +#if 0
>                         if (!strcmp(argv[argpos+1], "off")) {
>                                 inversion = DVBFE_INVERSION_OFF;
>                         } else if (!strcmp(argv[argpos+1], "on")) {
> @@ -180,11 +184,14 @@
>                         } else {
>                                 usage();
>                         }
> +#endif
>                         argpos+=2;
>                 } else if (!strcmp(argv[argpos], "-uk-ordering")) {
>                         if ((argc - argpos) < 1)
>                                 usage();
> +#if 0
>                         uk_ordering = 1;
> +#endif
>                 } else if (!strcmp(argv[argpos], "-timeout")) {
>                         if ((argc - argpos) < 2)
>                                 usage();
> @@ -211,6 +218,7 @@
>                 } else if (!strcmp(argv[argpos], "-out")) {
>                         if ((argc - argpos) < 3)
>                                 usage();
> +#if 0
>                         if (!strcmp(argv[argpos+1], "raw")) {
>                                 output_type = OUTPUT_TYPE_RAW;
>                         } else if (!strcmp(argv[argpos+1], "channels")) {
> @@ -225,6 +233,7 @@
>                         output_filename = argv[argpos+2];
>                         if (!strcmp(output_filename, "-"))
>                                 output_filename = NULL;
> +#endif
>                 } else {
>                         if ((argc - argpos) != 1)
>                                 usage();
> --

Sorry, I missed you earlier patch.

Please remove the obsolete flags and the #if 0. Those are pointless.

Regards,

Manu

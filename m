Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:14680 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755980Ab2HIMEI (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 9 Aug 2012 08:04:08 -0400
Message-ID: <5023A770.5080604@redhat.com>
Date: Thu, 09 Aug 2012 14:05:04 +0200
From: Hans de Goede <hdegoede@redhat.com>
MIME-Version: 1.0
To: Konke Radlow <kradlow@cisco.com>
CC: linux-media@vger.kernel.org, hverkuil@xs4all.nl, koradlow@gmail.com
Subject: Re: [RFC PATCH 2/2] Add rds-ctl tool (with changes proposed in RFC)
References: <[RFC PATCH 0/2] Add support for RDS decoding> <1344352315-1184-1-git-send-email-kradlow@cisco.com> <3bb2b81ed5c186756c83b9136b5aa43005d728a2.1344352285.git.kradlow@cisco.com>
In-Reply-To: <3bb2b81ed5c186756c83b9136b5aa43005d728a2.1344352285.git.kradlow@cisco.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

Comments inline.

On 08/07/2012 05:11 PM, Konke Radlow wrote:
> ---
>   Makefile.am               |    3 +-
>   configure.ac              |    1 +
>   utils/rds-ctl/Makefile.am |    5 +
>   utils/rds-ctl/rds-ctl.cpp |  959 +++++++++++++++++++++++++++++++++++++++++++++
>   4 files changed, 967 insertions(+), 1 deletion(-)
>   create mode 100644 utils/rds-ctl/Makefile.am
>   create mode 100644 utils/rds-ctl/rds-ctl.cpp
>
> diff --git a/Makefile.am b/Makefile.am
> index 621d8d9..8ef0d00 100644
> --- a/Makefile.am
> +++ b/Makefile.am

<Snip>

> +static void print_rds_data(const struct v4l2_rds *handle, uint32_t updated_fields)
> +{
> +	if (params.options[OptPrintBlock])
> +		updated_fields = 0xffffffff;
> +
> +	if ((updated_fields & V4L2_RDS_PI) &&
> +			(handle->valid_fields & V4L2_RDS_PI)) {
> +		printf("\nPI: %04x", handle->pi);
> +		print_rds_pi(handle);
> +	}
> +
> +	if (updated_fields & V4L2_RDS_PS &&
> +			handle->valid_fields & V4L2_RDS_PS) {
> +		printf("\nPS: ");
> +		for (int i = 0; i < 8; ++i) {
> +			/* filter out special characters */
> +			if (handle->ps[i] >= 0x20 && handle->ps[i] <= 0x7E)
> +				printf("%lc",handle->ps[i]);
> +			else
> +				printf(" ");
> +		}


Since ps now is a 0 terminated UTF-8 string you should be able to just do:
		printf("\nPS: %s", handle->ps);

And likewise for the other strings.

> +	}
> +
> +	if (updated_fields & V4L2_RDS_PTY && handle->valid_fields & V4L2_RDS_PTY)
> +		printf("\nPTY: %0u -> %s",handle->pty, v4l2_rds_get_pty_str(handle));
> +
> +	if (updated_fields & V4L2_RDS_PTYN && handle->valid_fields & V4L2_RDS_PTYN) {
> +		printf("\nPTYN: ");
> +		for (int i = 0; i < 8; ++i) {
> +			/* filter out special characters */
> +			if (handle->ptyn[i] >= 0x20 && handle->ptyn[i] <= 0x7E)
> +				printf("%lc",handle->ptyn[i]);
> +			else
> +				printf(" ");
> +		}

Likewise.

> +	}
> +
> +	if (updated_fields & V4L2_RDS_TIME) {
> +		printf("\nTime: %s", ctime(&handle->time));
> +	}
> +	if (updated_fields & V4L2_RDS_RT && handle->valid_fields & V4L2_RDS_RT) {
> +		printf("\nRT: ");
> +		for (int i = 0; i < handle->rt_length; ++i) {
> +			/* filter out special characters */
> +			if (handle->rt[i] >= 0x20 && handle->rt[i] <= 0x7E)
> +				printf("%lc",handle->rt[i]);
> +			else
> +				printf(" ");
> +		}

Likewise.

> +	}
> +
> +	if (updated_fields & V4L2_RDS_TP && handle->valid_fields & V4L2_RDS_TP)
> +		printf("\nTP: %s  TA: %s", (handle->tp)? "yes":"no",
> +			handle->ta? "yes":"no");
> +	if (updated_fields & V4L2_RDS_MS && handle->valid_fields & V4L2_RDS_MS)
> +		printf("\nMS Flag: %s", (handle->ms)? "Music" : "Speech");
> +	if (updated_fields & V4L2_RDS_ECC && handle->valid_fields & V4L2_RDS_ECC)
> +		printf("\nECC: %X%x, Country: %u -> %s",
> +		handle->ecc >> 4, handle->ecc & 0x0f, handle->pi >> 12,
> +		v4l2_rds_get_country_str(handle));
> +	if (updated_fields & V4L2_RDS_LC && handle->valid_fields & V4L2_RDS_LC)
> +		printf("\nLanguage: %u -> %s ", handle->lc,
> +		v4l2_rds_get_language_str(handle));
> +	if (updated_fields & V4L2_RDS_DI && handle->valid_fields & V4L2_RDS_DI)
> +		print_decoder_info(handle->di);
> +	if (updated_fields & V4L2_RDS_ODA &&
> +			handle->decode_information & V4L2_RDS_ODA) {
> +		for (int i = 0; i < handle->rds_oda.size; ++i)
> +			printf("\nODA Group: %02u%c, AID: %08x",handle->rds_oda.oda[i].group_id,
> +			handle->rds_oda.oda[i].group_version, handle->rds_oda.oda[i].aid);
> +	}
> +	if (updated_fields & V4L2_RDS_AF && handle->valid_fields & V4L2_RDS_AF)
> +		print_rds_af(&handle->rds_af);
> +	if (params.options[OptPrintBlock])
> +		printf("\n");
> +}
> +
> +static void read_rds(struct v4l2_rds *handle, const int fd, const int wait_limit)
> +{
> +	int byte_cnt = 0;
> +	int error_cnt = 0;
> +	uint32_t updated_fields = 0x00;
> +	struct v4l2_rds_data rds_data; /* read buffer for rds blocks */
> +
> +	while (!params.terminate_decoding) {
> +		memset(&rds_data, 0, sizeof(rds_data));
> +		if ((byte_cnt=read(fd, &rds_data, 3)) != 3) {
> +			if (byte_cnt == 0) {
> +				printf("\nEnd of input file reached \n");
> +				break;
> +			} else if(++error_cnt > 2) {
> +				fprintf(stderr, "\nError reading from "
> +					"device (no RDS data available)\n");
> +				break;
> +			}
> +			/* wait for new data to arrive: transmission of 1
> +			 * group takes ~88.7ms */
> +			usleep(wait_limit * 1000);
> +		}
> +		else if (byte_cnt == 3) {
> +			error_cnt = 0;
> +			/* true if a new group was decoded */
> +			if ((updated_fields = v4l2_rds_add(handle, &rds_data))) {
> +				print_rds_data(handle, updated_fields);
> +				if (params.options[OptVerbose])
> +					 print_rds_group(v4l2_rds_get_group(handle));
> +			}
> +		}
> +	}
> +	/* print a summary of all valid RDS-fields before exiting */
> +	printf("\nSummary of valid RDS-fields:");
> +	print_rds_data(handle, 0xFFFFFFFF);
> +}
> +
> +static void read_rds_from_fd(const int fd)
> +{
> +	struct v4l2_rds *rds_handle;
> +
> +	/* create an rds handle for the current device */
> +	if (!(rds_handle = v4l2_rds_create(true))) {
> +		fprintf(stderr, "Failed to init RDS lib: %s\n", strerror(errno));
> +		exit(1);
> +	}
> +
> +	/* try to receive and decode RDS data */
> +	read_rds(rds_handle, fd, params.wait_limit);
> +	print_rds_statistics(&rds_handle->rds_statistics);
> +
> +	v4l2_rds_destroy(rds_handle);
> +}
> +
> +static int parse_cl(int argc, char **argv)
> +{
> +	int i = 0;
> +	int idx = 0;
> +	int opt = 0;
> +	/* 26 letters in the alphabet, case sensitive = 26 * 2 possible
> +	 * short options, where each option requires at most two chars
> +	 * {option, optional argument} */
> +	char short_options[26 * 2 * 2 + 1];
> +
> +	if (argc == 1) {
> +		usage_hint();
> +		exit(1);
> +	}
> +	for (i = 0; long_options[i].name; i++) {
> +		if (!isalpha(long_options[i].val))
> +			continue;
> +		short_options[idx++] = long_options[i].val;
> +		if (long_options[i].has_arg == required_argument)
> +			short_options[idx++] = ':';
> +	}
> +	while (1) {
> +		int option_index = 0;
> +
> +		short_options[idx] = 0;
> +		opt = getopt_long(argc, argv, short_options,
> +				 long_options, &option_index);
> +		if (opt == -1)
> +			break;
> +
> +		params.options[(int)opt] = 1;
> +		switch (opt) {
> +		case OptSetDevice:
> +			strncpy(params.fd_name, optarg, 80);
> +			if (isdigit(optarg[0]) && optarg[1] == 0) {
> +				char newdev[20];
> +				sprintf(newdev, "/dev/radio%c", optarg[0]);
> +				strncpy(params.fd_name, newdev, 20);
> +			}
> +			break;
> +		case OptSetFreq:
> +			params.freq = strtod(optarg, NULL);
> +			break;
> +		case OptListDevices:
> +			print_devices(list_devices());
> +			break;
> +		case OptFreqSeek:
> +			parse_freq_seek(optarg, params.freq_seek);
> +			break;
> +		case OptTunerIndex:
> +			params.tuner_index = strtoul(optarg, NULL, 0);
> +			break;
> +		case OptOpenFile:
> +		{
> +			if (access(optarg, F_OK) != -1) {
> +				params.filemode_active = true;
> +				strncpy(params.fd_name, optarg, 80);
> +			} else {
> +				fprintf(stderr, "Unable to open file: %s\n", optarg);
> +				return -1;
> +			}
> +			/* enable the read-rds option by default for convenience */
> +			params.options[OptReadRds] = 1;
> +			break;
> +		}
> +		case OptWaitLimit:
> +			params.wait_limit = strtoul(optarg, NULL, 0);
> +			break;
> +		case ':':
> +			fprintf(stderr, "Option '%s' requires a value\n",
> +				argv[optind]);
> +			usage_hint();
> +			return 1;
> +		case '?':
> +			if (argv[optind])
> +				fprintf(stderr, "Unknown argument '%s'\n", argv[optind]);
> +			usage_hint();
> +			return 1;
> +		}
> +	}
> +	if (optind < argc) {
> +		printf("unknown arguments: ");
> +		while (optind < argc)
> +			printf("%s ", argv[optind++]);
> +		printf("\n");
> +		usage_hint();
> +		return 1;
> +	}
> +	if (params.options[OptAll]) {
> +		params.options[OptGetDriverInfo] = 1;
> +		params.options[OptGetFreq] = 1;
> +		params.options[OptGetTuner] = 1;
> +		params.options[OptSilent] = 1;
> +	}
> +
> +	return 0;
> +}
> +
> +static void print_driver_info(const struct v4l2_capability *vcap)
> +{
> +
> +	printf("Driver Info (%susing libv4l2):\n",
> +			params.options[OptUseWrapper] ? "" : "not ");
> +	printf("\tDriver name   : %s\n", vcap->driver);
> +	printf("\tCard type     : %s\n", vcap->card);
> +	printf("\tBus info      : %s\n", vcap->bus_info);
> +	printf("\tDriver version: %d.%d.%d\n",
> +			vcap->version >> 16,
> +			(vcap->version >> 8) & 0xff,
> +			vcap->version & 0xff);
> +	printf("\tCapabilities  : 0x%08X\n", vcap->capabilities);
> +	printf("%s", cap2s(vcap->capabilities).c_str());
> +	if (vcap->capabilities & V4L2_CAP_DEVICE_CAPS) {
> +		printf("\tDevice Caps   : 0x%08X\n", vcap->device_caps);
> +		printf("%s", cap2s(vcap->device_caps).c_str());
> +	}
> +}
> +
> +static void set_options(const int fd, const int capabilities, struct v4l2_frequency *vf,
> +			struct v4l2_tuner *tuner)
> +{
> +	int mode = -1;			/* set audio mode */
> +	double fac = 16;		/* factor for frequency division */
> +
> +	if (params.options[OptSetFreq]) {
> +		vf->type = V4L2_TUNER_RADIO;
> +		tuner->index = params.tuner_index;
> +		if (doioctl(fd, VIDIOC_G_TUNER, tuner) == 0) {
> +			fac = (tuner->capability & V4L2_TUNER_CAP_LOW) ? 16000 : 16;
> +			vf->type = tuner->type;
> +		}
> +
> +		vf->tuner = params.tuner_index;
> +		vf->frequency = __u32(params.freq * fac);
> +		if (doioctl(fd, VIDIOC_S_FREQUENCY, vf) == 0)
> +			printf("Frequency for tuner %d set to %d (%f MHz)\n",
> +				vf->tuner, vf->frequency, vf->frequency / fac);
> +	}
> +
> +	if (params.options[OptSetTuner]) {
> +		struct v4l2_tuner vt;
> +
> +		memset(&vt, 0, sizeof(struct v4l2_tuner));
> +		vt.index = params.tuner_index;
> +		if (doioctl(fd, VIDIOC_G_TUNER, &vt) == 0) {
> +			if (mode != -1)
> +				vt.audmode = mode;
> +			doioctl(fd, VIDIOC_S_TUNER, &vt);
> +		}
> +	}
> +
> +	if (params.options[OptFreqSeek]) {
> +		params.freq_seek.tuner = params.tuner_index;
> +		params.freq_seek.type = V4L2_TUNER_RADIO;
> +		doioctl(fd, VIDIOC_S_HW_FREQ_SEEK, &params.freq_seek);
> +	}
> +}
> +
> +static void get_options(const int fd, const int capabilities, struct v4l2_frequency *vf,
> +			struct v4l2_tuner *tuner)
> +{
> +	double fac = 16;		/* factor for frequency division */
> +
> +	if (params.options[OptGetFreq]) {
> +		vf->type = V4L2_TUNER_RADIO;
> +		tuner->index = params.tuner_index;
> +		if (doioctl(fd, VIDIOC_G_TUNER, tuner) == 0) {
> +			fac = (tuner->capability & V4L2_TUNER_CAP_LOW) ? 16000 : 16;
> +			vf->type = tuner->type;
> +		}
> +		vf->tuner = params.tuner_index;
> +		if (doioctl(fd, VIDIOC_G_FREQUENCY, vf) == 0)
> +			printf("Frequency for tuner %d: %d (%f MHz)\n",
> +				   vf->tuner, vf->frequency, vf->frequency / fac);
> +	}
> +
> +	if (params.options[OptGetTuner]) {
> +		struct v4l2_tuner vt;
> +
> +		memset(&vt, 0, sizeof(struct v4l2_tuner));
> +		vt.index = params.tuner_index;
> +		if (doioctl(fd, VIDIOC_G_TUNER, &vt) == 0) {
> +			printf("Tuner %d:\n", vt.index);
> +			printf("\tName                 : %s\n", vt.name);
> +			printf("\tCapabilities         : %s\n",
> +				tcap2s(vt.capability).c_str());
> +			if (vt.capability & V4L2_TUNER_CAP_LOW)
> +				printf("\tFrequency range      : %.1f MHz - %.1f MHz\n",
> +					 vt.rangelow / 16000.0, vt.rangehigh / 16000.0);
> +			else
> +				printf("\tFrequency range      : %.1f MHz - %.1f MHz\n",
> +					 vt.rangelow / 16.0, vt.rangehigh / 16.0);
> +			printf("\tSignal strength/AFC  : %d%%/%d\n",
> +				(int)((vt.signal / 655.35)+0.5), vt.afc);
> +			printf("\tCurrent audio mode   : %s\n", audmode2s(vt.audmode));
> +			printf("\tAvailable subchannels: %s\n",
> +					rxsubchans2s(vt.rxsubchans).c_str());
> +		}
> +	}
> +
> +	if (params.options[OptListFreqBands]) {
> +		struct v4l2_frequency_band band;
> +
> +		memset(&band, 0, sizeof(band));
> +		band.tuner = params.tuner_index;
> +		band.type = V4L2_TUNER_RADIO;
> +		band.index = 0;
> +		printf("ioctl: VIDIOC_ENUM_FREQ_BANDS\n");
> +		while (test_ioctl(fd, VIDIOC_ENUM_FREQ_BANDS, &band) >= 0) {
> +			if (band.index)
> +				printf("\n");
> +			printf("\tIndex          : %d\n", band.index);
> +			printf("\tModulation     : %s\n", modulation2s(band.modulation).c_str());
> +			printf("\tCapability     : %s\n", tcap2s(band.capability).c_str());
> +			if (band.capability & V4L2_TUNER_CAP_LOW)
> +				printf("\tFrequency Range: %.3f MHz - %.3f MHz\n",
> +				     band.rangelow / 16000.0, band.rangehigh / 16000.0);
> +			else
> +				printf("\tFrequency Range: %.3f MHz - %.3f MHz\n",
> +				     band.rangelow / 16.0, band.rangehigh / 16.0);
> +			band.index++;
> +		}
> +	}
> +}
> +
> +int main(int argc, char **argv)
> +{
> +	int fd = -1;
> +
> +	/* command args */
> +	struct v4l2_tuner tuner;	/* set_freq/get_freq */
> +	struct v4l2_capability vcap;	/* list_cap */
> +	struct v4l2_frequency vf;	/* get_freq/set_freq */
> +
> +	memset(&tuner, 0, sizeof(tuner));
> +	memset(&vcap, 0, sizeof(vcap));
> +	memset(&vf, 0, sizeof(vf));
> +	strcpy(params.fd_name, "/dev/radio0");
> +
> +	/* define locale for unicode support */
> +	if (!setlocale(LC_CTYPE, "")) {
> +		fprintf(stderr, "Can't set the specified locale!\n");
> +		return 1;
> +	}
> +	/* register signal handler for interrupt signal, to exit gracefully */
> +	signal(SIGINT, signal_handler_interrupt);
> +
> +	/* try to parse the command line */
> +	parse_cl(argc, argv);
> +	if (params.options[OptHelp]) {
> +		usage();
> +		exit(0);
> +	}
> +
> +	/* File Mode: disables all other features, except for RDS decoding */
> +	if (params.filemode_active) {
> +		if ((fd = open(params.fd_name, O_RDONLY|O_NONBLOCK)) < 0){
> +			perror("error opening file");
> +			exit(1);
> +		}
> +		read_rds_from_fd(fd);
> +		test_close(fd);
> +		exit(0);
> +	}
> +
> +	/* Device Mode: open the radio device as read-only and non-blocking */
> +	if (!params.options[OptSetDevice]) {
> +		/* check the system for RDS capable devices */
> +		dev_vec devices = list_devices();
> +		if (devices.size() == 0) {
> +			fprintf(stderr, "No RDS-capable device found\n");
> +			exit(1);
> +		}
> +		strncpy(params.fd_name, devices[0].c_str(), 80);
> +		printf("Using device: %s\n", params.fd_name);
> +	}
> +	if ((fd = test_open(params.fd_name, O_RDONLY | O_NONBLOCK)) < 0) {
> +		fprintf(stderr, "Failed to open %s: %s\n", params.fd_name,
> +			strerror(errno));
> +		exit(1);
> +	}
> +	doioctl(fd, VIDIOC_QUERYCAP, &vcap);
> +
> +	/* Info options */
> +	if (params.options[OptGetDriverInfo])
> +		print_driver_info(&vcap);
> +	/* Set options */
> +	set_options(fd, vcap.capabilities, &vf, &tuner);
> +	/* Get options */
> +	get_options(fd, vcap.capabilities, &vf, &tuner);
> +	/* RDS decoding */
> +	if (params.options[OptReadRds])
> +		read_rds_from_fd(fd);
> +
> +	test_close(fd);
> +	exit(app_result);
> +}
>


Other then that this looks good to me.

Regards,

Hans
